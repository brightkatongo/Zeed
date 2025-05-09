from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth.password_validation import validate_password
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import FarmerProfile

class LoginSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        # Add custom claims to token
        token['username'] = user.username
        token['email'] = user.email
        return token

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, required=True)
    farm_name = serializers.CharField(required=False)
    farm_type = serializers.CharField(required=False)
    location = serializers.CharField(required=False)
    phone_number = serializers.CharField(required=False)

    class Meta:
        model = User
        fields = ('username', 'password', 'password2', 'email', 'first_name', 'last_name',
                 'farm_name', 'farm_type', 'location', 'phone_number')
        extra_kwargs = {
            'first_name': {'required': True},
            'last_name': {'required': True},
            'email': {'required': True}
        }

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        return attrs

    def create(self, validated_data):
        farm_name = validated_data.pop('farm_name', None)
        farm_type = validated_data.pop('farm_type', None)
        location = validated_data.pop('location', None)
        phone_number = validated_data.pop('phone_number', None)
        validated_data.pop('password2')
        
        user = User.objects.create(
            username=validated_data['username'],
            email=validated_data['email'],
            first_name=validated_data['first_name'],
            last_name=validated_data['last_name']
        )
        
        user.set_password(validated_data['password'])
        user.save()
        
        FarmerProfile.objects.create(
            user=user,
            farm_name=farm_name,
            farm_type=farm_type,
            location=location,
            phone_number=phone_number
        )
        
        return user

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']
