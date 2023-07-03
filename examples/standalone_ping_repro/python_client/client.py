import grpc
import time

import generated.cacheping_pb2_grpc


def main():
    channel = grpc.secure_channel(
        target='cache.cell-alpha-dev.preprod.a.momentohq.com:443',
        credentials=grpc.ssl_channel_credentials()
    )
        # .insecure_channel('localhost:9000')
    stub = generated.cacheping_pb2_grpc.PingStub(channel)
    request = generated.cacheping_pb2._PingRequest()
    # request = generated.hello_pb2.HelloInput()
    for i in range(100_000):
        start_time = time.perf_counter_ns()
        response = stub.Ping(request)
        print(f"GOT RESPONSE: {response.__class__}")
        end_time = time.perf_counter_ns()
        duration_ms = (end_time - start_time) / 1e6
        print(f"Issued grpc request in {duration_ms} ms")


main()
