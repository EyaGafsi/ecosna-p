from scans.tasks import run_blip_caption
from django.http import JsonResponse

from scans.views import save_image

def upload_image(request):
    # Enregistre l’image temporairement
    image_path = save_image(request.FILES["image"])
    
    # Lance le traitement IA en tâche de fond via Celery
    task = run_blip_caption.delay(image_path)
    
    return JsonResponse({"status": "processing", "task_id": task.id})
