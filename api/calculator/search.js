// ========================================================================
// API ENDPOINT: Search Jobs
// ========================================================================
// File: api/calculator/search.js
// Purpose: Search job titles with autocomplete
// Database: Updated column names
// ========================================================================

import { sql } from '@vercel/postgres';

export default async function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  
  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }
  
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }
  
  const { q } = req.query;
  
  if (!q || q.length < 2) {
    return res.status(400).json({ 
      error: 'Query parameter required (minimum 2 characters)' 
    });
  }
  
  try {
    // Search with NEW column names
    const { rows } = await sql`
      SELECT 
        id,
        job_title,
        usa_market_rate,
        usa_startekk_onsite,
        canada_rate_nearshore,
        india_rate_offshore,
        category,
        seniority
      FROM job_rates 
      WHERE job_title ILIKE ${`%${q}%`}
      ORDER BY job_title ASC
      LIMIT 20
    `;
    
    res.status(200).json(rows);
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({ 
      error: 'Search error',
      message: error.message 
    });
  }
}
