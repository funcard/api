# Venues

Endpoints:

- [Get venues](#get-venues)

## Get venues

###### Example JSON Response

<!-- START GET /hlsrapi/api/venues?limit=3 -->
```json
[
  {
    "id": 36135,
    "name": "Test Venue"
  },
  {
    "id": 36134,
    "name": "Test Venue"
  },
  {
    "id": 36133,
    "name": "Test Venue"
  }
]
```
<!-- END -->

###### Copy as cURL

```shell
curl -X GET /hlsrapi/api/venues
```