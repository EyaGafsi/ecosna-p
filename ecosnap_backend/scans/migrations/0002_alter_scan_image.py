# Generated by Django 5.2.1 on 2025-05-30 22:47

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('scans', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='scan',
            name='image',
            field=models.ImageField(upload_to='uploads/'),
        ),
    ]
