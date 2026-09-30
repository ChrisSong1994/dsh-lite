import { HttpResponse, http } from 'msw'

export const handlers = [
  http.get('/api/v1/sessions', () => HttpResponse.json({ items: [], total: 0 })),
]
