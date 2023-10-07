from django.db import models

# Create your models here.
class Pentest(models.Model):
    """
    Pentest model, which stores the information about the pentest.
    """
    
    file = models.FileField(upload_to='pentests/')

    def __str__(self):
        return self.file.name
    
class Vulnerability(models.Model):
    """
    Vulnerability model, which stores the information about the vulnerability.
    """
    
    title = models.CharField(max_length=100)

    author = models.CharField(max_length=100)

    description = models.TextField()

    severity = models.CharField(max_length=100)

    poc_steps_to_reproduce = models.TextField()

    request = models.TextField()

    response = models.TextField()

    def __str__(self):
        return self.file.name