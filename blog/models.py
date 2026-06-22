from django.contrib.postgres.indexes import GinIndex, OpClass
from django.db import models
from django.db.models import Q
from django.db.models.functions import Cast, Upper
from django.utils import timezone


class User(models.Model):
    username = models.CharField(max_length=64, unique=True)
    email = models.CharField(max_length=255)
    display_name = models.CharField(max_length=128)
    bio = models.TextField(blank=True)
    created_at = models.DateTimeField(default=timezone.now)

    def __str__(self) -> str:
        return self.username

    class Meta:
        indexes = [
            models.Index(fields=["email"], name="blog_user_email_idx"),
        ]


class Tag(models.Model):
    name = models.CharField(max_length=64, unique=True)
    slug = models.CharField(max_length=64, unique=True)
    created_at = models.DateTimeField(default=timezone.now)

    def __str__(self) -> str:
        return self.name


class Post(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name="posts")
    title = models.CharField(max_length=255)
    body = models.TextField()
    is_published = models.BooleanField(default=True)
    view_count = models.IntegerField(default=0)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)
    tags = models.ManyToManyField(Tag, related_name="posts", blank=True)

    def __str__(self) -> str:
        return self.title

    class Meta:
        indexes = [
            models.Index(
                fields=["-created_at"],
                name="blog_post_pub_created_idx",
                condition=Q(is_published=True),
            ),
            GinIndex(
                OpClass(
                    Upper(Cast("title", output_field=models.TextField())),
                    name="gin_trgm_ops",
                ),
                name="blog_post_title_pub_trgm_idx",
                condition=Q(is_published=True),
            ),
            GinIndex(
                OpClass(
                    Upper(Cast("body", output_field=models.TextField())),
                    name="gin_trgm_ops",
                ),
                name="blog_post_body_pub_trgm_idx",
                condition=Q(is_published=True),
            ),
        ]


class Comment(models.Model):
    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name="comments")
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name="comments")
    body = models.TextField()
    created_at = models.DateTimeField(default=timezone.now)

    class Meta:
        indexes = [
            models.Index(fields=["post", "created_at"], name="blog_comment_post_created_idx"),
        ]
