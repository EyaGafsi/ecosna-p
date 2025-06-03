from celery import shared_task
from transformers import BlipProcessor, BlipForConditionalGeneration
from PIL import Image
from .models import Scan
from pyfcm import FCMNotification
from .models import Device

# Détection par mots-clés simples
def classify_caption(caption):
    caption = caption.lower()

    keywords = {
        'plastic': ['plastic bottle', 'plastic', 'container'],
        'metal': ['can', 'aluminum', 'tin', 'metal'],
        'glass': ['glass', 'jar', 'bottle'],
        'paper': ['paper', 'cardboard', 'box', 'carton'],
        'organic': ['banana peel', 'food waste', 'apple core','food'],
        'other': ['diaper', 'styrofoam', 'trash', 'garbage']
    }

    for category, terms in keywords.items():
        for term in terms:
            if term in caption:
                return category

    return 'unknown'

def is_recyclable_category(category):
    return category in ['plastic', 'metal', 'glass', 'paper']

def run_blip_caption(image_path):
    processor = BlipProcessor.from_pretrained('Salesforce/blip-image-captioning-base')
    model = BlipForConditionalGeneration.from_pretrained('Salesforce/blip-image-captioning-base')

    image = Image.open(image_path).convert('RGB')
    inputs = processor(image, return_tensors="pt")
    out = model.generate(**inputs)
    caption = processor.decode(out[0], skip_special_tokens=True)
    return caption

@shared_task
def process_scan(scan_id):
    scan = Scan.objects.get(id=scan_id)
    image_path = scan.image.path 

    # 1. Générer la description
    caption = run_blip_caption(image_path)

    # 2. Déterminer catégorie
    category = classify_caption(caption)

    # 3. Déterminer si c’est recyclable
    recyclable = is_recyclable_category(category)

    # 4. Enregistrer dans la base
    scan.result = caption
    scan.category = category
    scan.is_recyclable = recyclable
    scan.save()

import requests

def send_fcm_via_http(token, title, body):
    import os
    fcm_server_key = os.environ.get('FCM_SERVER_KEY', 'Z3uko0_k9GVSvdHUNfxpRgmTrGNqCoDKWlz5qVYBVHc')
    headers = {
        "Authorization": f"key={fcm_server_key}",
        "Content-Type": "application/json",
    }
    data = {
        "to": token,
        "notification": {
            "title": title,
            "body": body,
        },
        "priority": "high",
    }
    response = requests.post("https://fcm.googleapis.com/fcm/send", headers=headers, json=data)
    print(response.status_code, response.json())

@shared_task
def send_reminder_notifications():
    devices = Device.objects.all()
    for device in devices:
        send_fcm_via_http(
            token=device.fcm_token,
            title="🛎️ N'oubliez pas !",
            body="Venez scanner un objet ou lire un article écologique."
        )
