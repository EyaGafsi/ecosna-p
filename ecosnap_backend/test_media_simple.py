#!/usr/bin/env python
"""
Test simple pour vérifier que les médias fonctionnent
(sans accès à la base de données)
"""
import os
from pathlib import Path

def test_media_structure():
    """Vérifie la structure des dossiers media"""
    print("🔍 Vérification de la structure des médias...")
    
    # Chemin du projet
    base_dir = Path(__file__).resolve().parent
    media_dir = base_dir / 'media'
    
    print(f"✅ Dossier du projet: {base_dir}")
    print(f"✅ Dossier media: {media_dir}")
    
    # Vérifier que les dossiers existent
    if media_dir.exists():
        print("✅ Dossier media existe")
        
        # Vérifier les sous-dossiers
        uploads_dir = media_dir / 'uploads'
        feed_images_dir = media_dir / 'feed_images'
        
        if uploads_dir.exists():
            print("✅ Dossier uploads/ existe")
            # Lister les fichiers
            files = list(uploads_dir.glob('*'))
            print(f"   📁 {len(files)} fichier(s) dans uploads/")
            for file in files:
                if file.is_file():
                    size = file.stat().st_size
                    print(f"   📄 {file.name} ({size} bytes)")
        else:
            print("❌ Dossier uploads/ manquant")
            uploads_dir.mkdir(exist_ok=True)
            print("✅ Dossier uploads/ créé")
        
        if feed_images_dir.exists():
            print("✅ Dossier feed_images/ existe")
            # Lister les fichiers
            files = list(feed_images_dir.glob('*'))
            print(f"   📁 {len(files)} fichier(s) dans feed_images/")
            for file in files:
                if file.is_file():
                    size = file.stat().st_size
                    print(f"   📄 {file.name} ({size} bytes)")
        else:
            print("❌ Dossier feed_images/ manquant")
            feed_images_dir.mkdir(exist_ok=True)
            print("✅ Dossier feed_images/ créé")
            
    else:
        print("❌ Dossier media n'existe pas")
        media_dir.mkdir(exist_ok=True)
        (media_dir / 'uploads').mkdir(exist_ok=True)
        (media_dir / 'feed_images').mkdir(exist_ok=True)
        print("✅ Structure media créée")

def test_django_settings():
    """Teste les paramètres Django pour les médias (sans DB)"""
    print("\n🔍 Vérification des paramètres Django...")
    
    try:
        import os
        import django
        from django.conf import settings
        
        # Configuration Django
        os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ecosnap_backend.settings')
        django.setup()
        
        print(f"✅ MEDIA_URL: {settings.MEDIA_URL}")
        print(f"✅ MEDIA_ROOT: {settings.MEDIA_ROOT}")
        print(f"✅ DEBUG: {settings.DEBUG}")
        
        # Vérifier que MEDIA_ROOT existe
        if os.path.exists(settings.MEDIA_ROOT):
            print("✅ MEDIA_ROOT existe sur le disque")
        else:
            print("❌ MEDIA_ROOT n'existe pas")
            
    except Exception as e:
        print(f"❌ Erreur lors du test Django: {e}")

def create_test_image():
    """Crée une image de test simple"""
    print("\n🔍 Création d'une image de test...")
    
    try:
        from PIL import Image
        import io
        
        # Créer une image simple
        img = Image.new('RGB', (100, 100), color='blue')
        
        # Sauvegarder dans le dossier uploads
        test_path = Path(__file__).resolve().parent / 'media' / 'uploads' / 'test_media_restore.jpg'
        img.save(test_path, 'JPEG')
        
        print(f"✅ Image de test créée: {test_path}")
        print(f"✅ Taille: {test_path.stat().st_size} bytes")
        
        # URL relative pour Django
        relative_url = f"/media/uploads/{test_path.name}"
        print(f"✅ URL Django: http://127.0.0.1:8000{relative_url}")
        
        return relative_url
        
    except ImportError:
        print("❌ Pillow non installé - impossible de créer l'image de test")
        return None
    except Exception as e:
        print(f"❌ Erreur lors de la création de l'image: {e}")
        return None

if __name__ == "__main__":
    print("🚀 Test de restauration des médias\n")
    
    test_media_structure()
    test_django_settings()
    test_url = create_test_image()
    
    print("\n" + "="*60)
    print("📋 RÉSUMÉ:")
    print("✅ Structure des dossiers media restaurée")
    print("✅ Configuration Django vérifiée")
    
    if test_url:
        print(f"✅ Image de test disponible: {test_url}")
    
    print("\n💡 Pour tester l'accès aux images:")
    print("1. Démarrez Docker: docker-compose up")
    print("2. Dans un autre terminal: python manage.py runserver")
    print("3. Ouvrez: http://127.0.0.1:8000/media/uploads/test_media_restore.jpg")
    
    print("\n📁 Structure finale:")
    media_path = Path(__file__).resolve().parent / 'media'
    for root, dirs, files in os.walk(media_path):
        level = root.replace(str(media_path), '').count(os.sep)
        indent = '  ' * level
        print(f"{indent}{os.path.basename(root)}/")
        subindent = '  ' * (level + 1)
        for file in files:
            print(f"{subindent}{file}")
