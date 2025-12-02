import { sql } from '@vercel/postgres';

/**
 * GET /api/calculator/categories
 * 
 * Returns all unique job categories with count
 * Used for filtering in calculator UI
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
    // Get all categories with job count
    const query = await sql`
      SELECT 
        category,
        COUNT(*) as job_count,
        AVG(usa_market_rate) as avg_market_rate,
        AVG(usa_startekk_rate) as avg_startekk_rate,
        AVG(india_rate) as avg_india_rate
      FROM job_rates
      WHERE category IS NOT NULL
      GROUP BY category
      ORDER BY category ASC
    `;

    const categories = query.rows.map(cat => ({
      name: cat.category,
      jobCount: parseInt(cat.job_count),
      averageRates: {
        market: parseFloat(parseFloat(cat.avg_market_rate).toFixed(2)),
        startekk: parseFloat(parseFloat(cat.avg_startekk_rate).toFixed(2)),
        india: parseFloat(parseFloat(cat.avg_india_rate).toFixed(2))
      }
    }));

    // Get total job count
    const totalQuery = await sql`SELECT COUNT(*) as total FROM job_rates`;
    const totalJobs = parseInt(totalQuery.rows[0].total);

    res.status(200).json({
      success: true,
      totalJobs: totalJobs,
      categoryCount: categories.length,
      categories: categories
    });

  } catch (error) {
    console.error('Database error:', error);
    res.status(500).json({ 
      success: false,
      error: 'Failed to fetch categories',
      message: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
    });
  }
}
