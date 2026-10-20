import time
import requests
import concurrent.futures
import argparse

def send_request(url, model, prompt):
    start = time.time()
    r = requests.post(url, json={
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 30
    })
    latency = time.time() - start
    tokens = r.json()["usage"]["completion_tokens"]
    return latency, tokens

def benchmark(concurrency, num_requests):
    url = "http://localhost:8000/v1/chat/completions"
    # 注意：这里的模型名要和启动时一致
    model = "/root/autodl-tmp/models/Qwen2-7B-Instruct-GPTQ-Int4" 
    
    latencies = []
    total_tokens = 0
    start = time.time()
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=concurrency) as executor:
        futures = [executor.submit(send_request, url, model, "你好") for _ in range(num_requests)]
        for f in concurrent.futures.as_completed(futures):
            lat, tok = f.result()
            latencies.append(lat)
            total_tokens += tok
            
    elapsed = time.time() - start
    throughput = total_tokens / elapsed
    
    print(f"并发数: {concurrency}, 请求数: {num_requests}")
    print(f"总耗时: {elapsed:.2f}s")
    print(f"吞吐量: {throughput:.2f} tokens/s")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--concurrency", type=int, default=10)
    parser.add_argument("--requests", type=int, default=100)
    args = parser.parse_args()
    
    benchmark(args.concurrency, args.requests)