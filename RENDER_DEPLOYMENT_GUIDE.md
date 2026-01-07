# Deploying TwentyCRM to Render

## Quick Start Guide

### Prerequisites

- Render account (you already have one ✓)
- GitHub repository with TwentyCRM code
- Docker Hub account (optional, but recommended for custom builds)

### Option 1: Quick Deploy (Using Official TwentyCRM Docker Image)

**Recommended for fastest deployment**

#### Step 1: Push to GitHub

```bash
git add .
git commit -m "Ready for Render deployment with EzyShield customizations"
git push origin main
```

#### Step 2: Connect Repository to Render

1. Go to [dashboard.render.com](https://dashboard.render.com)
2. Click **"New +"**
3. Select **"Web Service"**
4. Connect your GitHub account
5. Select your `twentyCRM` repository
6. Branch: `main`
7. Name: `ezyshield-crm`
8. Region: Choose closest to your users (e.g., Singapore (SGE1) for Australia)
9. Click **"Create Web Service"**

#### Step 3: Configure Service

**Runtime:** Docker

**Build Command:** (leave blank - uses Dockerfile CMD)

**Start Command:** (leave blank - uses Dockerfile ENTRYPOINT)

**Environment Variables:** Render will automatically import from `render.yaml`

**Advanced:**

- Instance Type: Free (for testing) or Standard ($7/month)
- Disk: 5 GB

Click **"Create Web Service"**

#### Step 4: Set Up Database

1. In Render dashboard, click **"New +"**
2. Select **"PostgreSQL"**
3. Name: `ezyshield-postgres`
4. Database: `default`
5. User: `postgres`
6. Password: Click **"Generate"** and save it somewhere safe
7. Region: Same as web service
8. Plan: Free (for testing) or Standard ($7/month)
9. Click **"Create Database"**

#### Step 5: Set Up Redis

1. In Render dashboard, click **"New +"**
2. Select **"Redis"**
3. Name: `ezyshield-redis`
4. Region: Same as web service
5. Plan: Free (for testing) or Standard ($15/month)
6. Click **"Create Redis"**

#### Step 6: Create Worker Service

1. In Render dashboard, click **"New +"**
2. Select **"Cron Job"** (for background tasks)
3. Name: `ezyshield-worker`
4. Schedule: `* * * * *` (run continuously)
5. Command: `node dist/queue-worker/queue-worker`
6. Connect to: `ezyshield-crm` (web service)

#### Step 7: Update Environment Variables

**For Web Service (`ezyshield-crm`):**

```
SERVER_URL=https://ezyshield-crm.onrender.com
FRONT_BASE_URL=https://ezyshield-crm.onrender.com
APP_SECRET=<generate-random-string>
PG_DATABASE_HOST=<postgres-host-from-render>
PG_DATABASE_PORT=5432
REDIS_HOST=<redis-host-from-render>
REDIS_PORT=6379
DISABLE_DB_MIGRATIONS=false
```

**For Worker Service (`ezyshield-worker`):**

```
SERVER_URL=https://ezyshield-crm.onrender.com
FRONT_BASE_URL=https://ezyshield-crm.onrender.com
APP_SECRET=<same-as-web-service>
PG_DATABASE_HOST=<postgres-host-from-render>
PG_DATABASE_PORT=5432
REDIS_HOST=<redis-host-from-render>
REDIS_PORT=6379
DISABLE_DB_MIGRATIONS=true
DISABLE_CRON_JOBS_REGISTRATION=true
```

#### Step 8: Deploy

1. Click **"Manual Deploy"** on `ezyshield-crm` web service
2. Click **"Clear build cache & deploy"**
3. Wait for build (~5-10 minutes)
4. Check logs for any errors
5. Once web service is healthy, deploy worker

#### Step 9: Access Your CRM

Go to: `https://ezyshield-crm.onrender.com`

**First Workspace:**

- Sign up with email
- Create workspace name: "EzyShield"
- Workspace ID will be: `ezyshield-crm-dev-workspace-001` (from our customizations)

### Option 2: Deploy Using render.yaml

**Alternative: Use Render's Blueprint feature**

1. Go to [dashboard.render.com](https://dashboard.render.com)
2. Click **"New +"** → **"Blueprints"**
3. Upload or paste `render.yaml` from your repository root
4. Render will auto-create all services:
   - Web service (server)
   - Worker service (background jobs)
   - PostgreSQL database
   - Redis cache
5. Click **"Apply Blueprint"**
6. Follow prompts to connect repository and deploy

### Accessing Services

After deployment, you can access:

- **Web Service:** `https://ezyshield-crm.onrender.com`
- **Dashboard:** [dashboard.render.com](https://dashboard.render.com) → View your services
- **Logs:** Click on service → **"Logs"** tab
- **Metrics:** Click on service → **"Metrics"** tab
- **Shell:** Click on service → **"Shell"** (debugging)

### Environment Variable Details

**Required Variables:**

| Variable           | Description            | Example                              |
| ------------------ | ---------------------- | ------------------------------------ |
| `SERVER_URL`       | Your frontend URL      | `https://ezyshield-crm.onrender.com` |
| `FRONT_BASE_URL`   | Base URL for frontend  | `https://ezyshield-crm.onrender.com` |
| `APP_SECRET`       | Random secret for auth | Generate random string               |
| `PG_DATABASE_HOST` | Postgres host          | `dpg-cxxxxx...us-east-1.render.com`  |
| `PG_DATABASE_PORT` | Postgres port          | `5432`                               |
| `REDIS_HOST`       | Redis host             | `red-xxxxx...us-east-1.render.com`   |
| `REDIS_PORT`       | Redis port             | `6379`                               |

**Optional Variables (for integrations):**

```
# Email (for outreach sequences)
EMAIL_DRIVER=smtp
EMAIL_SMTP_HOST=smtp.gmail.com
EMAIL_SMTP_PORT=465
EMAIL_SMTP_USER=your-email@gmail.com
EMAIL_SMTP_PASSWORD=your-app-password

# Storage (for file uploads)
STORAGE_TYPE=local
# Or for S3-compatible storage:
STORAGE_TYPE=s3
STORAGE_S3_REGION=us-east-1
STORAGE_S3_NAME=your-bucket-name
STORAGE_S3_ENDPOINT=https://s3.amazonaws.com
```

### Troubleshooting

#### Service Not Starting

1. Check **"Logs"** tab
2. Common issues:
   - Database connection failed → Verify `PG_DATABASE_HOST` is correct
   - Redis connection failed → Verify `REDIS_HOST` is correct
   - Port binding error → Ensure `NODE_PORT=3000` is set

#### Database Migration Failed

1. Check worker logs
2. Verify `DISABLE_DB_MIGRATIONS=false` on web service
3. Verify `DISABLE_DB_MIGRATIONS=true` and `DISABLE_CRON_JOBS_REGISTRATION=true` on worker

#### Build Fails

1. Check if Docker Hub image is accessible
2. Verify Dockerfile exists
3. Clear build cache and redeploy

#### Slow Performance

1. Upgrade from Free to Standard instance type
2. Check Render's **"Metrics"** tab for CPU/memory usage
3. Consider using Redis for caching (already configured)

### Costs Estimate (Render Pricing)

**Free Tier (Development):**

- Web Service: $0
- Postgres: $0
- Redis: $0
- Worker: $0
- **Total: $0/month**

**Standard Tier (Production Recommended):**

- Web Service (Standard): $7/month
- Postgres (Starter 10GB): $7/month
- Redis (Starter): $15/month
- Worker: Included with web service
- **Total: ~$29/month**

**Scale as Needed:**

- Add more instances: +$7/instance
- Increase disk: +$0.10/GB-month
- Higher database plans available

### Monitoring & Alerts

1. Go to service → **"Metrics"** tab
2. Monitor:
   - CPU usage
   - Memory usage
   - Response time
   - Error rate
3. Set up alerts:
   - Service → **"Alerts"**
   - Configure email/SMS alerts for downtime

### Backup Strategy

Render includes:

- Automated daily backups for PostgreSQL
- Point-in-time recovery
- 7-day retention on free tier

**Recommended:** Export workspace data regularly:

- Settings → Data Export
- Download CSV/JSON of companies, opportunities, etc.

### Next Steps After Deployment

1. **Test Custom Fields:**
   - Create a new company
   - Verify EzyShield fields appear (Company Type, Integration Preference, etc.)
   - Create an opportunity
   - Verify EzyShield stages appear (New Lead → Closed Won)

2. **Create Views:**
   - Go to Companies → Create View
   - Filter by `companyType = 'PAYMENT_COMPANY'`
   - Save as "Payment Companies Pipeline"

3. **Test Research Note:**
   - Go to "Research Notes" (should be in navigation)
   - Create a research note
   - Link to a company/person
   - Verify all fields work

4. **Set Up Outreach Sequence:**
   - Create an opportunity
   - Add outreach sequence steps
   - Test scheduling

5. **Connect AI (Phase 2):**
   - Add Anthropic API key to environment variables
   - Test AI research workflow
   - Verify fit scores are calculated

### Security Recommendations

1. **Generate Strong `APP_SECRET`:**

   ```bash
   openssl rand -hex 32
   ```

2. **Use Environment Variables:**
   - Never hardcode secrets in code
   - Use Render's environment variable management

3. **Enable HTTPS:**
   - Render provides free SSL certificates
   - Force HTTPS redirects in app settings

4. **Rate Limiting:**
   - Configure rate limits in TwentyCRM settings
   - Monitor API usage in Render logs

### Domain Configuration (Optional)

To use custom domain like `crm.ezyshield.com.au`:

1. In Render dashboard → `ezyshield-crm` service
2. Click **"Custom Domains"**
3. Click **"Add Domain"**
4. Enter: `crm.ezyshield.com.au`
5. Update DNS records as shown by Render:
   ```
   A    @    <render-ip-address>
   CNAME www   <render-service-url>
   ```
6. Wait for SSL certificate (1-24 hours)

### Rollback Strategy

If deployment breaks something:

1. Go to service → **"Deploys"** tab
2. Find previous successful deploy
3. Click **"Rollback"**
4. Service will revert to that version

### Production Checklist

Before going live:

- [ ] All EzyShield custom fields appear in UI
- [ ] Can create companies with all custom fields
- [ ] Can create opportunities with custom sales stages
- [ ] Research Note and Outreach Sequence objects accessible
- [ ] Database migrations run successfully
- [ ] Worker is running background jobs
- [ ] Email configuration works (if using)
- [ ] SSL/HTTPS enabled
- [ ] Custom domain configured (if needed)
- [ ] Monitoring/alerts set up
- [ ] Backup strategy tested
- [ ] Team members can sign up and access workspace

---

## Need Help?

- **Render Docs:** [render.com/docs](https://render.com/docs)
- **TwentyCRM Docs:** [docs.twenty.com](https://docs.twenty.com)
- **Render Support:** [support@render.com](mailto:support@render.com)

## Notes

- The official `twentycrm/twenty:latest` Docker image is maintained by the TwentyCRM team
- For production, consider building your own Docker image with EzyShield customizations
- Free tier may have cold starts (30-60s to wake up)
- For Australia-based users, consider Singapore (SGE1) region for better latency
