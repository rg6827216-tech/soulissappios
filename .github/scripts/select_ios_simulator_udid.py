import json
import re
import sys

devices = json.load(sys.stdin).get("devices", {})
candidates = []

for runtime, runtime_devices in devices.items():
    match = re.search(r"iOS[- ](\d+)(?:[-.](\d+))?", runtime)
    if not match:
        continue

    version = (int(match.group(1)), int(match.group(2) or 0))
    for device in runtime_devices:
        if device.get("isAvailable") and device.get("name", "").startswith("iPhone"):
            candidates.append((version, device["name"], device["udid"]))

candidates.sort(key=lambda item: (item[0][0], item[0][1], item[1]), reverse=True)
print(candidates[0][2] if candidates else "")
