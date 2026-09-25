import { render, screen } from '@testing-library/react'
import { describe, expect, it } from 'vitest'

import App from './App'

describe('App', () => {
  it('renders the placeholder heading', () => {
    render(<App />)

    expect(screen.getByRole('heading', { level: 1, name: 'DSH Lite' })).toBeInTheDocument()
  })

  it('intercepts the sessions request with MSW', async () => {
    const response = await fetch('/api/v1/sessions')

    expect(response.status).toBe(200)
    await expect(response.json()).resolves.toEqual({ items: [], total: 0 })
  })
})