import { sql } from '@vercel/postgres';

/**
 * POST /api/calculator/calculate
 * 
 * Calculate savings based on job, location, team size, and hours
 * Body: { jobId, location, teamSize, hoursPerWeek }
 * 
 * Locations: "usa-market", "usa-startekk", "india-offshore", "nearshore"
 */
export default async function handler(req, res) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  // Handle preflight
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { jobId, location, teamSize, hoursPerWeek } = req.body;

    // Validation
    if (!jobId || !location || !teamSize || !hoursPerWeek) {
      return res.status(400).json({
        success: false,
        error: 'Missing required fields',
        required: ['jobId', 'location', 'teamSize', 'hoursPerWeek']
      });
    }

    // Fetch job from database
    const query = await sql`
      SELECT 
        id,
        job_title,
        usa_market_rate,
        usa_startekk_rate,
        india_rate,
        category,
        seniority
      FROM job_rates
      WHERE id = ${jobId}
    `;

    if (query.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Job not found'
      });
    }

    const job = query.rows[0];

    // Parse rates
    const marketRate = parseFloat(job.usa_market_rate);
    const startekkRate = parseFloat(job.usa_startekk_rate);
    const indiaRate = parseFloat(job.india_rate);

    // Calculate nearshore rate (estimate: 85% of StartTekk USA rate)
    const nearshoreRate = startekkRate * 0.85;

    // Determine hourly rate based on location
    let selectedRate;
    let selectedLocation;
    
    switch(location) {
      case 'usa-market':
        selectedRate = marketRate;
        selectedLocation = 'USA Market Rate';
        break;
      case 'usa-startekk':
        selectedRate = startekkRate;
        selectedLocation = 'USA with StartTekk';
        break;
      case 'india-offshore':
        selectedRate = indiaRate;
        selectedLocation = 'India (Offshore)';
        break;
      case 'nearshore':
        selectedRate = nearshoreRate;
        selectedLocation = 'Nearshore (Mexico/Canada)';
        break;
      default:
        return res.status(400).json({
          success: false,
          error: 'Invalid location',
          validLocations: ['usa-market', 'usa-startekk', 'india-offshore', 'nearshore']
        });
    }

    // Calculate costs
    const weeksPerYear = 52;
    const hoursPerYear = hoursPerWeek * weeksPerYear;
    const costPerPerson = selectedRate * hoursPerYear;
    const totalCost = costPerPerson * teamSize;

    // Calculate savings vs market rate
    const marketCostPerPerson = marketRate * hoursPerYear;
    const marketTotalCost = marketCostPerPerson * teamSize;
    const annualSavings = marketTotalCost - totalCost;
    const savingsPercentage = ((annualSavings / marketTotalCost) * 100).toFixed(1);

    // Calculate 5-year savings
    const fiveYearSavings = annualSavings * 5;

    // Build response
    const response = {
      success: true,
      calculation: {
        job: {
          id: job.id,
          title: job.job_title,
          category: job.category,
          seniority: job.seniority
        },
        inputs: {
          location: selectedLocation,
          teamSize: parseInt(teamSize),
          hoursPerWeek: parseInt(hoursPerWeek),
          hoursPerYear: hoursPerYear
        },
        rates: {
          market: marketRate,
          startekk: startekkRate,
          india: indiaRate,
          nearshore: parseFloat(nearshoreRate.toFixed(2)),
          selected: selectedRate
        },
        costs: {
          perHour: selectedRate,
          perPerson: parseFloat(costPerPerson.toFixed(2)),
          total: parseFloat(totalCost.toFixed(2)),
          marketTotal: parseFloat(marketTotalCost.toFixed(2))
        },
        savings: {
          annual: parseFloat(annualSavings.toFixed(2)),
          percentage: parseFloat(savingsPercentage),
          fiveYear: parseFloat(fiveYearSavings.toFixed(2)),
          monthly: parseFloat((annualSavings / 12).toFixed(2))
        }
      }
    };

    // Add comparison data for all locations (useful for UI)
    response.comparison = {
      'usa-market': {
        location: 'USA Market Rate',
        rate: marketRate,
        annualCost: parseFloat((marketRate * hoursPerYear * teamSize).toFixed(2)),
        savings: 0,
        savingsPercentage: 0
      },
      'usa-startekk': {
        location: 'USA with StartTekk',
        rate: startekkRate,
        annualCost: parseFloat((startekkRate * hoursPerYear * teamSize).toFixed(2)),
        savings: parseFloat((marketTotalCost - (startekkRate * hoursPerYear * teamSize)).toFixed(2)),
        savingsPercentage: parseFloat((((marketTotalCost - (startekkRate * hoursPerYear * teamSize)) / marketTotalCost) * 100).toFixed(1))
      },
      'nearshore': {
        location: 'Nearshore (Mexico/Canada)',
        rate: parseFloat(nearshoreRate.toFixed(2)),
        annualCost: parseFloat((nearshoreRate * hoursPerYear * teamSize).toFixed(2)),
        savings: parseFloat((marketTotalCost - (nearshoreRate * hoursPerYear * teamSize)).toFixed(2)),
        savingsPercentage: parseFloat((((marketTotalCost - (nearshoreRate * hoursPerYear * teamSize)) / marketTotalCost) * 100).toFixed(1))
      },
      'india-offshore': {
        location: 'India (Offshore)',
        rate: indiaRate,
        annualCost: parseFloat((indiaRate * hoursPerYear * teamSize).toFixed(2)),
        savings: parseFloat((marketTotalCost - (indiaRate * hoursPerYear * teamSize)).toFixed(2)),
        savingsPercentage: parseFloat((((marketTotalCost - (indiaRate * hoursPerYear * teamSize)) / marketTotalCost) * 100).toFixed(1))
      }
    };

    res.status(200).json(response);

  } catch (error) {
    console.error('Calculation error:', error);
    res.status(500).json({ 
      success: false,
      error: 'Failed to calculate savings',
      message: process.env.NODE_ENV === 'development' ? error.message : 'Internal server error'
    });
  }
}
