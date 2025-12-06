import { sql } from '@vercel/postgres';

/**
 * API Endpoint: GET /api/calculator/jobs
 * Returns all 238 job titles with rates from database
 * Used by cost calculator for autocomplete and calculations
 */
export default async function handler(req, res) {
  // Only allow GET requests
  if (req.method !== 'GET') {
    return res.status(405).json({ 
      error: 'Method not allowed',
      message: 'This endpoint only accepts GET requests'
    });
  }

  try {
    // Query database for all jobs with rates
    const { rows } = await sql`
      SELECT 
        id,
        job_title,
        usa_market_rate,
        usa_startekk_rate,
        india_rate,
        seniority,
        category
      FROM job_rates
      ORDER BY job_title ASC
    `;

    // Return all jobs
    return res.status(200).json({
      success: true,
      count: rows.length,
      jobs: rows
    });

  } catch (error) {
    console.error('Database query error:', error);
    
    return res.status(500).json({ 
      error: 'Database error',
      message: 'Failed to fetch jobs from database',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
}
