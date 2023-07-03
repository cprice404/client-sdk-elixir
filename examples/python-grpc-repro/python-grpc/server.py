import asyncio
import grpc

import generated.hello_pb2_grpc


class HelloServer(generated.hello_pb2_grpc.HelloServicer):
    def Hello(self, request, context):
        return generated.hello_pb2.HelloOutput(hello="hi there")


async def serve() -> None:
    server = grpc.aio.server()
    generated.hello_pb2_grpc.add_HelloServicer_to_server(HelloServer(), server)
    server.add_insecure_port('[::]:9000')
    print("Starting server")
    await server.start()
    print("Server started")
    print("Waiting for server to exit")
    await server.wait_for_termination()
    print("Server exited")


loop = asyncio.get_event_loop()
loop.run_until_complete(serve())
loop.close()
