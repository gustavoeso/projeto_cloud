from locust import HttpUser, TaskSet, task, between

class UserBehavior(TaskSet):
    @task(1)
    def index(self):
        self.client.get("/")

    @task(2)
    def create_user(self):
        self.client.post("/create_user", json={"user_id": "1", "user_name": "TestUser"})

    @task(3)
    def list_users(self):
        self.client.get("/list_users")

    @task(4)
    def delete_user(self):
        self.client.delete("/delete_user", params={"user_id": "1"})

class WebsiteUser(HttpUser):
    tasks = [UserBehavior]
    wait_time = between(1, 5)
    