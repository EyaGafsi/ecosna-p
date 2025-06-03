#!/usr/bin/env python
"""
Test HTTP pour vérifier l'accès aux images via Django
"""
import requests
import time

def test_server_status():
    """Vérifie si le serveur Django répond"""
    try:
        response = requests.get("http://127.0.0.1:8000/admin/", timeout=5)
        print(f"✅ Serveur Django accessible (Status: {response.status_code})")
        return True
    except requests.exceptions.ConnectionError:
        print("❌ Serveur Django non accessible")
        return False
    except Exception as e:
        print(f"⚠️ Erreur lors du test serveur: {e}")
        return False

def test_image_access(image_url, description):
    """Teste l'accès à une image spécifique"""
    print(f"\n🔍 Test: {description}")
    print(f"📍 URL: {image_url}")
    
    try:
        response = requests.get(image_url, timeout=10)
        
        if response.status_code == 200:
            print(f"✅ Image accessible!")
            print(f"✅ Content-Type: {response.headers.get('Content-Type', 'Non spécifié')}")
            print(f"✅ Taille: {len(response.content)} bytes")
            
            # Vérifier que c'est bien une image
            content_type = response.headers.get('Content-Type', '')
            if content_type.startswith('image/'):
                print("✅ Contenu confirmé comme image")
            else:
                print(f"⚠️ Content-Type inattendu: {content_type}")
                
        elif response.status_code == 404:
            print("❌ Image non trouvée (404)")
            print("💡 Vérifiez que le fichier existe dans le dossier media")
        else:
            print(f"❌ Erreur HTTP: {response.status_code}")
            print(f"❌ Réponse: {response.text[:200]}...")
            
    except requests.exceptions.ConnectionError:
        print("❌ Impossible de se connecter au serveur")
    except requests.exceptions.Timeout:
        print("❌ Timeout lors de la requête")
    except Exception as e:
        print(f"❌ Erreur: {e}")

def main():
    """Fonction principale de test"""
    print("🚀 Test d'accès HTTP aux images Django\n")
    
    # Vérifier que le serveur répond
    if not test_server_status():
        print("\n💡 Instructions pour démarrer le serveur:")
        print("1. Ouvrez un terminal et naviguez vers le dossier du projet")
        print("2. Démarrez Docker: docker-compose up")
        print("3. Dans un autre terminal: python manage.py runserver")
        print("4. Relancez ce script")
        return
    
    # Liste des images à tester
    test_images = [
        ("http://127.0.0.1:8000/media/uploads/test_media_restore.jpg", "Image de test créée"),
        ("http://127.0.0.1:8000/media/uploads/scan_test.jpg", "Image de scan test"),
        ("http://127.0.0.1:8000/media/uploads/test_image.jpg", "Image de test originale"),
        ("http://127.0.0.1:8000/media/feed_images/feed_test.jpg", "Image de feed test"),
    ]
    
    # Tester chaque image
    for url, description in test_images:
        test_image_access(url, description)
        time.sleep(0.5)  # Petite pause entre les tests
    
    print("\n" + "="*60)
    print("📋 RÉSUMÉ DES TESTS:")
    print("Si toutes les images sont accessibles, votre configuration media fonctionne!")
    print("\n💡 Pour utiliser les images dans votre application:")
    print("- Les modèles Scan et Feed peuvent maintenant sauvegarder des images")
    print("- Les URLs des images seront automatiquement générées")
    print("- Les images seront servies via Django en mode DEBUG")

if __name__ == "__main__":
    main()
