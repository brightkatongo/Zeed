// This file represents the Django models that would be used in the backend
// It's included here for reference only and is not used in the frontend

/*
# Django Models for Agrifinance

from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _

class User(AbstractUser):
    USER_ROLES = (
        ('farmer', 'Farmer'),
        ('buyer', 'Buyer'),
        ('transporter', 'Transporter'),
        ('admin', 'Administrator'),
    )
    
    role = models.CharField(max_length=20, choices=USER_ROLES, default='farmer')
    phone_number = models.CharField(max_length=20, blank=True)
    location = models.CharField(max_length=100, blank=True)
    verified = models.BooleanField(default=False)
    profile_image = models.ImageField(upload_to='profile_images/', blank=True, null=True)
    
    def __str__(self):
        return self.username

class Product(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    category = models.CharField(max_length=50)
    unit = models.CharField(max_length=20, default='kg')
    
    def __str__(self):
        return self.name

class MarketPrice(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='prices')
    price = models.DecimalField(max_digits=10, decimal_places=2)
    unit = models.CharField(max_length=20, default='kg')
    location = models.CharField(max_length=100)
    date = models.DateField()
    
    class Meta:
        ordering = ['-date']
    
    def __str__(self):
        return f"{self.product.name} - {self.price} per {self.unit} ({self.date})"

class ProductListing(models.Model):
    STATUS_CHOICES = (
        ('active', 'Active'),
        ('sold', 'Sold'),
        ('expired', 'Expired'),
        ('draft', 'Draft'),
    )
    
    seller = models.ForeignKey(User, on_delete=models.CASCADE, related_name='listings')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    unit = models.CharField(max_length=20, default='kg')
    price_per_unit = models.DecimalField(max_digits=10, decimal_places=2)
    description = models.TextField(blank=True)
    location = models.CharField(max_length=100)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='active')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.product.name} ({self.quantity} {self.unit}) by {self.seller.username}"

class ProductImage(models.Model):
    listing = models.ForeignKey(ProductListing, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='product_images/')
    
    def __str__(self):
        return f"Image for {self.listing}"

class Transaction(models.Model):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
    )
    
    listing = models.ForeignKey(ProductListing, on_delete=models.CASCADE, related_name='transactions')
    buyer = models.ForeignKey(User, on_delete=models.CASCADE, related_name='purchases')
    seller = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sales')
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    total_amount = models.DecimalField(max_digits=12, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Transaction #{self.id} - {self.listing.product.name}"

class WeatherData(models.Model):
    location = models.CharField(max_length=100)
    temperature = models.DecimalField(max_digits=5, decimal_places=2)
    condition = models.CharField(max_length=50)
    humidity = models.IntegerField()
    wind_speed = models.DecimalField(max_digits=5, decimal_places=2)
    date = models.DateField()
    farming_tip = models.TextField(blank=True)
    
    class Meta:
        ordering = ['-date']
    
    def __str__(self):
        return f"Weather for {self.location} on {self.date}"

class Notification(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    title = models.CharField(max_length=100)
    message = models.TextField()
    is_read = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['-created_at']
    
    def __str__(self):
        return f"Notification for {self.user.username}: {self.title}"

class TransportService(models.Model):
    STATUS_CHOICES = (
        ('available', 'Available'),
        ('booked', 'Booked'),
        ('in_transit', 'In Transit'),
        ('completed', 'Completed'),
    )
    
    provider = models.ForeignKey(User, on_delete=models.CASCADE, related_name='transport_services')
    vehicle_type = models.CharField(max_length=50)
    capacity = models.DecimalField(max_digits=10, decimal_places=2)
    capacity_unit = models.CharField(max_length=20, default='kg')
    price_per_km = models.DecimalField(max_digits=8, decimal_places=2)
    current_location = models.CharField(max_length=100)
    available_from = models.DateField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='available')
    
    def __str__(self):
        return f"{self.vehicle_type} ({self.capacity} {self.capacity_unit}) by {self.provider.username}"

class TransportBooking(models.Model):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('confirmed', 'Confirmed'),
        ('in_transit', 'In Transit'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
    )
    
    service = models.ForeignKey(TransportService, on_delete=models.CASCADE, related_name='bookings')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='transport_bookings')
    pickup_location = models.CharField(max_length=100)
    delivery_location = models.CharField(max_length=100)
    distance_km = models.DecimalField(max_digits=8, decimal_places=2)
    cargo_description = models.TextField()
    cargo_weight = models.DecimalField(max_digits=10, decimal_places=2)
    pickup_date = models.DateField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    total_cost = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Transport booking from {self.pickup_location} to {self.delivery_location}"

class FinancialService(models.Model):
    SERVICE_TYPES = (
        ('loan', 'Loan'),
        ('insurance', 'Insurance'),
        ('savings', 'Savings'),
    )
    
    name = models.CharField(max_length=100)
    provider = models.CharField(max_length=100)
    service_type = models.CharField(max_length=20, choices=SERVICE_TYPES)
    description = models.TextField()
    requirements = models.TextField()
    interest_rate = models.DecimalField(max_digits=5, decimal_places=2, null=True, blank=True)
    min_amount = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    max_amount = models.DecimalField(max_digits=12, decimal_places=2, null=True, blank=True)
    
    def __str__(self):
        return f"{self.name} by {self.provider}"

class FinancialApplication(models.Model):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
    )
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='financial_applications')
    service = models.ForeignKey(FinancialService, on_delete=models.CASCADE, related_name='applications')
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    purpose = models.TextField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.service.name} application by {self.user.username}"

class AIAssistantChat(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='ai_chats')
    message = models.TextField()
    response = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['created_at']
    
    def __str__(self):
        return f"Chat with {self.user.username} at {self.created_at}"
*/
