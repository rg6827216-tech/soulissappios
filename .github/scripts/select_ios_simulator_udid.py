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
            candidates.append(
                {
                    "version": version,
                    "name": device["name"],
                    "udid": device["udid"],
                }
            )

candidates.sort(
    key=lambda candidate: (
        candidate["version"][0],
        candidate["version"][1],
        candidate["name"],
    ),
    reverse=True,
)
print(candidates[0]["udid"] if candidates else "")
