from django.urls import path
from .views import ScanView, MyScansView, RegisterDeviceView

urlpatterns = [
    path('', ScanView.as_view()),
    path('my-scans/<int:pk>/', MyScansView.as_view(), name='my-scans'),
    path('device/', RegisterDeviceView.as_view()),

]
