# EzyShield CRM Customizations

## Overview

This document outlines the customizations made to TwentyCRM for EzyShield's B2B SaaS sales operations targeting payment companies, labor hire firms, and SMBs using Xero/MYOB.

## Custom Objects

### 1. Research Note (`researchNote`)

**Purpose:** Store AI-generated research notes for SDR prospecting

**Fields:**

- `researchType` (SELECT): LinkedIn, Website, News, Social Media, Industry Reports, Manual
- `keyFindings` (TEXT): Important insights from research
- `personalizedOutreachAngle` (TEXT): Suggested personalized outreach angle
- `researchDate` (DATE_TIME): When research was completed
- `aiModelUsed` (TEXT): Which AI model generated this research (default: Claude 3.5 Sonnet)
- `citations` (TEXT): Source URLs/references
- `researchQualityScore` (NUMBER): Quality of research data (1-10)
- `personName` (TEXT): Name of person researched (if applicable)
- `personTitle` (TEXT): Title/role of person researched

**Relations:**

- `company` (MANY_TO_ONE): Company that was researched
- `person` (MANY_TO_ONE): Person that was researched

### 2. Outreach Sequence (`outreachSequence`)

**Purpose:** Track automated outreach sequences for prospecting

**Fields:**

- `sequenceStep` (NUMBER): Step number in outreach sequence
- `channel` (SELECT): Email, LinkedIn, Phone, SMS
- `scheduledDate` (DATE_TIME): When outreach is scheduled for
- `status` (SELECT): Scheduled, Sent, Opened, Replied, Bounced, Skipped
- `messageTemplate` (TEXT): Template message used
- `personalizedContent` (TEXT): Customized content sent
- `openCount` (NUMBER): Number of times opened (default: 0)
- `clickCount` (NUMBER): Number of times links clicked (default: 0)
- `sentDate` (DATE_TIME): When outreach was actually sent
- `errorMessage` (TEXT): Any error that occurred

**Relations:**

- `opportunity` (MANY_TO_ONE): Associated opportunity

## Custom Fields - Company Object

**Target Market Segmentation Fields:**

1. **`companyType`** (SELECT)
   - Options: Payment Company, Labor Hire, SMB
   - Description: Target market segment for EzyShield solution

2. **`integrationPreference`** (SELECT)
   - Options: API, ABA File, Both
   - Description: Preferred integration method for EzyShield

3. **`accountingSoftware`** (SELECT)
   - Options: Xero, MYOB, QuickBooks, Other
   - Description: Primary accounting software used by company

**Technical & Business Assessment Fields:**

4. **`currentPaymentProvider`** (TEXT)
   - Description: Current payment processing solution being used

5. **`estimatedMonthlyTransactionVolume`** (SELECT)
   - Options: < $10K, $10K-$100K, $100K-$1M, >$1M
   - Description: Estimated number of monthly payment transactions

6. **`technicalComplexity`** (SELECT)
   - Options: Low, Medium, High
   - Description: Perceived technical complexity for integration

7. **`fraudRiskLevel`** (SELECT)
   - Options: High, Medium, Low
   - Description: Assessed risk level for payment fraud

## Custom Fields - Opportunity Object

**Sales Process Fields:**

1. **`salesStage`** (SELECT)
   - Options: New Lead, Research & Qualification, Technical Assessment, API Integration Discussion, Demo Scheduled, Proposal Sent, Contract Review, Closed Won, Closed Lost
   - Description: EzyShield specific sales process stage

2. **`integrationType`** (SELECT)
   - Options: API, ABA File, Both
   - Description: Type of integration being discussed

3. **`estimatedImplementationMonths`** (NUMBER)
   - Description: Estimated implementation time in months

**Lead Qualification & Source:**

4. **`leadSource`** (SELECT)
   - Options: Outbound, Inbound, Referral, Partnership, Other
   - Description: Source of lead

5. **`fitScore`** (NUMBER)
   - Description: AI-calculated lead fit score (1-10)
   - Settings: min: 1, max: 10

**Additional Tracking:**

6. **`rejectionReason`** (TEXT)
   - Description: Reason for opportunity loss

7. **`decisionMakerTitle`** (SELECT)
   - Options: CEO, CTO, CFO, VP Engineering, VP Finance, Head of Payments, Other
   - Description: Title of primary decision maker

## File Locations

### Backend Files

**Custom Objects:**

- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/custom-objects/constants/research-note-custom-object-seed.constant.ts`
- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/custom-objects/constants/outreach-sequence-custom-object-seed.constant.ts`

**Custom Fields:**

- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/custom-fields/constants/ezyshield-company-custom-field-seeds.constant.ts`
- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/custom-fields/constants/ezyshield-opportunity-custom-field-seeds.constant.ts`
- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/custom-fields/constants/research-note-custom-field-seeds.constant.ts`
- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/custom-fields/constants/outreach-sequence-custom-field-seeds.constant.ts`

**Relation Fields:**

- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/custom-fields/constants/research-note-custom-relation-field-seeds.constant.ts`
- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/custom-fields/constants/outreach-sequence-custom-relation-field-seeds.constant.ts`

**Configuration:**

- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/core/constants/seeder-workspaces.constant.ts` (EzyShield workspace ID added)
- `packages/twenty-server/src/engine/workspace-manager/dev-seeder/metadata/services/dev-seeder-metadata.service.ts` (Updated with EzyShield configuration)

## Usage Instructions

### 1. Seeding the Customizations

To seed these customizations into a new EzyShield workspace:

```typescript
// This happens automatically via DevSeederService when creating the EzyShield workspace
// The workspace ID is: 'ezyshield-crm-dev-workspace-001'
```

### 2. Accessing Custom Fields

Once seeded, these fields will be available:

**Company Fields:**

- Create/Edit a company record
- See new fields: Company Type, Integration Preference, Accounting Software, etc.

**Opportunity Fields:**

- Create/Edit an opportunity
- See new fields: Sales Stage, Integration Type, Lead Source, Fit Score, etc.

### 3. Creating Research Notes

1. Go to "Research Notes" in the navigation
2. Click "Create Research Note"
3. Fill in:
   - Select Research Type (LinkedIn, Website, etc.)
   - Enter Key Findings
   - Add Outreach Angle
   - Select related Company and/or Person
   - Note AI Model used
   - Add Citations
4. Save

### 4. Setting Up Outreach Sequences

1. Open an Opportunity
2. Create Outreach Sequence records for each step
3. Configure:
   - Sequence Step (1, 2, 3...)
   - Channel (Email, LinkedIn, Phone, SMS)
   - Schedule Date
   - Status (Scheduled)
   - Message Template
   - Personalized Content
4. Save

### 5. Lead Scoring

Use the `fitScore` field on opportunities:

- Automatically calculate via AI based on:
  - Company type match
  - Integration preference alignment
  - Transaction volume potential
  - Fraud risk exposure
- Score: 1-10 (higher = better fit)

## Suggested Views & Dashboards

### Company Views

1. **Payment Companies Pipeline**
   - Filter: `companyType = 'PAYMENT_COMPANY'`
   - Group by: `fraudRiskLevel`
   - Sort by: `annualRecurringRevenue` (descending)

2. **Labor Hire Pipeline**
   - Filter: `companyType = 'LABOR_HIRE'`
   - Group by: `integrationPreference`
   - Sort by: `employees` (descending)

3. **Xero/MYOB SMBs**
   - Filter: `companyType = 'SMB' AND accountingSoftware IN ('XERO', 'MYOB')`
   - Group by: `accountingSoftware`
   - Sort by: `estimatedMonthlyTransactionVolume` (descending)

### Opportunity Views

1. **High-Priority Leads**
   - Filter: `fitScore >= 8`
   - Sort by: `fitScore` (descending)

2. **Pipeline by Sales Stage**
   - Filter: All opportunities
   - Group by: `salesStage`
   - Sort by: `fitScore` (descending)

3. **Outbound Pipeline**
   - Filter: `leadSource = 'OUTBOUND'`
   - Group by: `salesStage`
   - Sort by: `fitScore` (descending)

### Research Dashboard

1. **Research Queue**
   - Object: Research Notes
   - Filter: `researchDate IS NULL` (not yet researched)
   - Sort by: Creation date (ascending)

2. **Recent Research Activity**
   - Object: Research Notes
   - Filter: Last 7 days
   - Group by: `researchType`
   - Sort by: `researchDate` (descending)

3. **Research Quality Metrics**
   - Object: Research Notes
   - Aggregate: Average `researchQualityScore`
   - Group by: `aiModelUsed`

## AI SDR Workflow Integration

### Step 1: Add Company

1. Create Company record
2. Fill in:
   - Company Type (Payment Company, Labor Hire, or SMB)
   - Integration Preference (API, ABA File, or Both)
   - Accounting Software (Xero, MYOB, etc.)
   - Current Payment Provider
   - Monthly Transaction Volume
   - Technical Complexity
   - Fraud Risk Level

### Step 2: Trigger AI Research

```typescript
// Automated workflow (to be implemented):
// 1. New company added → Trigger AI research
// 2. Research using Claude 3.5 Sonnet:
//    - LinkedIn profile scraping
//    - Website analysis
//    - News/press releases
//    - Social media activity
//    - Industry reports
// 3. Create ResearchNote record with findings
// 4. Calculate and set fitScore on related Opportunity
```

### Step 3: Create Opportunity

1. Create Opportunity from Company
2. Fill in:
   - Sales Stage: "New Lead"
   - Lead Source: "Outbound" / "Inbound" / etc.
   - Integration Type
   - Estimated Implementation Months
   - Decision Maker Title

### Step 4: Set Up Outreach Sequence

1. Create OutreachSequence records:
   - Step 1: Initial Email (scheduled for Day 1)
   - Step 2: LinkedIn Connection (scheduled for Day 3)
   - Step 3: Follow-up Email (scheduled for Day 7)
   - Step 4: Phone Call (scheduled for Day 10)
   - Step 5: Final Email (scheduled for Day 14)

2. Each step includes:
   - Message Template
   - Personalized Content (from Research Notes)
   - Scheduled Date

### Step 5: Monitor & Update

1. Track openCount, clickCount on each OutreachSequence
2. Update status as responses come in (Opened → Replied)
3. Move Opportunity through sales stages
4. Log rejectionReason if lost

## Next Steps

### Phase 2: AI Integration (Week 2)

1. **Set up AI Research Service**
   - Integrate Claude 3.5 Sonnet API
   - Build research prompts for each company type
   - Create research pipeline

2. **Build Research Automation**
   - Trigger on company creation
   - Queue research jobs
   - Store results in Research Notes

3. **Lead Scoring Algorithm**
   - Implement fitScore calculation logic
   - Consider: company type, integration preference, volume, risk
   - Auto-update opportunities

### Phase 3: Outreach Automation (Week 3)

1. **Email Templates**
   - Create template library for each company type
   - Personalization variables (name, findings, angles)
   - A/B testing framework

2. **Sequence Scheduling**
   - Auto-schedule based on opportunity creation
   - Multi-channel sequences (Email + LinkedIn + Phone)
   - Smart timing (consider time zones)

3. **Tracking & Analytics**
   - Email open/click tracking
   - Reply detection
   - Performance metrics by channel/sequence

### Phase 4: Advanced Features (Week 4+)

1. **LinkedIn Integration**
   - PhantomBuster for profile scraping
   - Auto-connect functionality
   - Message sequencing

2. **Third-Party Integrations**
   - Clearbit API for company enrichment
   - Gmail/Outlook for sending emails
   - Slack notifications for activity

3. **Advanced Analytics**
   - Pipeline velocity
   - Conversion rates by company type
   - Win/loss analysis
   - Outreach effectiveness metrics

## Notes

- All custom fields are marked as `isActive: true` and will be visible in the UI
- Company and Opportunity fields use the existing standard objects
- ResearchNote and OutreachSequence are new custom objects
- All customizations are scoped to the EzyShield workspace (`ezyshield-crm-dev-workspace-001`)
- Relations are set up correctly to link custom objects to standard objects
