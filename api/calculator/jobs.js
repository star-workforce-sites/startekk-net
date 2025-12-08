// API Endpoint: /api/calculator/jobs.js
// Returns all jobs with NEW column names after database migration
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
  
  try {
    // Query with NEW column names (after migration)
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
      ORDER BY job_title ASC
    `;
    
    console.log(`✅ Loaded ${rows.length} jobs`);
    res.status(200).json(rows);
    
  } catch (error) {
    console.error('❌ Database error:', error);
    res.status(500).json({ 
      error: 'Database error',
      message: error.message 
    });
  }
}
