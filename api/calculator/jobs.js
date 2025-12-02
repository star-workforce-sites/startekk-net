import { sql } from '@vercel/postgres';

/**
 * GET /api/calculator/jobs
 * GET /api/calculator/jobs?search=engineer
 * 
 * Returns all job titles or filtered by search term
 * Used for autocomplete and job selection in calculator
 */
export default async function handler(req, res) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { search } = req.query;

    let query;
    let results;

    if (search && search.trim()) {
      // Search with fuzzy matching (case-insensitive, partial match)
      const searchTerm = `%${search.trim()}%`;
      query = await sql`
        SELECT 
          id,
          job_title,
          usa_market_rate,
          usa_startekk_rate,
          india_rate,
          category,
          seniority
        FROM job_rates
        WHERE job_title ILIKE ${searchTerm}
        ORDER BY job_title ASC
        LIMIT 50
      `;
      results = query.rows;
    } else {
      // Return all jobs (for dropdown population)
      query = await sql`
        SELECT 
          id,
          job_title,
          usa_market_rate,
          usa_startekk_rate,
          india_rate,
          category,
          seniority
        FROM job_rates
        ORDER BY job_title ASC
      `;
      results = query.rows;
    }

    // Format response
    const jobs = results.map(job => ({
      id: job.id,
      title: job.job_title,
      rates: {
        market: parseFloat(job.usa_market_rate),
        startekk: parseFloat(job.usa_startekk_rate),
        india: parseFloat(job.india_rate)
      },
      category: job.category,
      seniority: job.seniority
    }));

    res.status(200).json({
      success: true,
      count: jobs.length,
      jobs: jobs
    });

  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({ 
      success: false,
      error: 'Failed to fetch jobs',
      message: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
    });
  }
}
