from locust import HttpUser, TaskSet, task, between

class WebsiteTest(HttpUser):
    wait_time = between(0.5, 3.0)

    @task(1)
    def index(self):
        self.client.get("http://shiftEmotionSpotifyBlancer-378386110.us-west-2.elb.amazonaws.com/")