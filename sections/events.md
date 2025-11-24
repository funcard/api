# Events

Endpoints:

- [Get events](#get-events)

## Get events

###### Example JSON Response

<!-- START GET /hlsrapi/api/events?limit=3 -->
```json
[
  {
    "id": 17941,
    "name": "Test Event 17941",
    "venue_id": 36135,
    "start_date": "2025-11-23T20:30:00.000Z",
    "end_date": "2025-11-23T20:30:00.000Z"
  },
  {
    "id": 17940,
    "name": "Test Event 17940",
    "venue_id": 36133,
    "start_date": "2025-11-23T20:30:00.000Z",
    "end_date": "2025-11-23T20:30:00.000Z"
  },
  {
    "id": 17939,
    "name": "Test Event 17939",
    "venue_id": 36131,
    "start_date": "2025-11-23T20:30:00.000Z",
    "end_date": "2025-11-23T20:30:00.000Z"
  }
]
```
<!-- END -->

###### Copy as cURL

```shell
curl -X GET /hlsrapi/api/events
```