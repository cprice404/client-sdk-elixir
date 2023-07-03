import grpc
import time

import generated.hello_pb2_grpc


def main():
    channel = grpc.insecure_channel('localhost:9000')
    stub = generated.hello_pb2_grpc.HelloStub(channel)
    request = generated.hello_pb2.HelloInput()
    for i in range(100_000):
        start_time = time.perf_counter_ns()
        response = stub.Hello(request)
        print(f"GOT RESPONSE: {response}")
        end_time = time.perf_counter_ns()
        duration_ms = (end_time - start_time) / 1e6
        print(f"Issued grpc request in {duration_ms} ms")


main()
