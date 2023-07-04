import http.client
import time


def main():
    # http_client = http.client.HTTPConnection('localhost:8000')
    http_client = http.client.HTTPSConnection('localhost:8000')
    for i in range(100_000):
        start_time = time.perf_counter_ns()
        http_client.request('GET', "/")
        response = http_client.getresponse()
        data = response.read()
        end_time = time.perf_counter_ns()
        duration_ms = (end_time - start_time) / 1e6
        print(f"Issued HTTP request in {duration_ms} ms")

main()
