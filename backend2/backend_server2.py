#this is the backend server 1
from http.server import BaseHTTPRequestHandler , HTTPServer

class handle(BaseHTTPRequestHandler):
    total_requests = 0
    unique_users = set()
    identity = "backend_server2"

    #we use do_GET instead of init becuase init runs once wehn we crate an object 
    # to handle http request we use do_GET or do_POST they create whenever they get a request
    def do_GET(self):
        handle.total_requests += 1
        user_id = self.headers.get("X_User_ID")
        if user_id:
            handle.unique_users.add(user_id)

        response = (
            f"Backend: {handle.identity}\n"
            f"Total req: {handle.total_requests}\n"
            f"Unique users: {len(handle.unique_users)}\n"
        )

        self.send_header()
        self.end_headers()
        self.wfile.write(response.encode())

        #run only when __name__ is __main__ not when we import this file to use its functions
if __name__ == "__main__":
    HTTPServer(("0.0.0.0",8000), handle).serve_forever()