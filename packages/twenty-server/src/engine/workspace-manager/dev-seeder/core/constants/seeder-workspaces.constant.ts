import { WorkspaceActivationStatus } from 'twenty-shared/workspace';

import { type WorkspaceEntity } from 'src/engine/core-modules/workspace/workspace.entity';

export const WORKSPACE_FIELDS_TO_SEED = [
  'id',
  'displayName',
  'subdomain',
  'inviteHash',
  'logo',
  'activationStatus',
  'isTwoFactorAuthenticationEnforced',
  'version',
  'workspaceCustomApplicationId',
] as const satisfies (keyof WorkspaceEntity)[];

export type CreateWorkspaceInput = Pick<
  WorkspaceEntity,
  (typeof WORKSPACE_FIELDS_TO_SEED)[number]
>;

export const SEED_APPLE_WORKSPACE_ID = '20202020-1c25-4d02-bf25-6aeccf7ea419';
export const SEED_YCOMBINATOR_WORKSPACE_ID =
  '3b8e6458-5fc1-4e63-8563-008ccddaa6db';
export const SEED_EZYSHIELD_WORKSPACE_ID = 'ezyshield-crm-dev-workspace-001';

export type SeededWorkspacesIds =
  | typeof SEED_APPLE_WORKSPACE_ID
  | typeof SEED_YCOMBINATOR_WORKSPACE_ID
  | typeof SEED_EZYSHIELD_WORKSPACE_ID;

export const SEEDER_CREATE_WORKSPACE_INPUT = {
  [SEED_APPLE_WORKSPACE_ID]: {
    id: SEED_APPLE_WORKSPACE_ID,
    displayName: 'Apple',
    subdomain: 'apple',
    inviteHash: 'apple.dev-invite-hash',
    logo: 'https://twentyhq.github.io/placeholder-images/workspaces/apple-logo.png',
    activationStatus: WorkspaceActivationStatus.PENDING_CREATION, // will be set to active after default role creation
    isTwoFactorAuthenticationEnforced: false,
  },
  [SEED_YCOMBINATOR_WORKSPACE_ID]: {
    id: SEED_YCOMBINATOR_WORKSPACE_ID,
    displayName: 'YCombinator',
    subdomain: 'yc',
    inviteHash: 'yc.dev-invite-hash',
    logo: 'https://twentyhq.github.io/placeholder-images/workspaces/ycombinator-logo.png',
    activationStatus: WorkspaceActivationStatus.PENDING_CREATION, // will be set to active after default role creation
    isTwoFactorAuthenticationEnforced: false,
  },
  [SEED_EZYSHIELD_WORKSPACE_ID]: {
    id: SEED_EZYSHIELD_WORKSPACE_ID,
    displayName: 'EzyShield',
    subdomain: 'ezyshield',
    inviteHash: 'ezyshield.dev-invite-hash',
    logo: 'https://cdn.prod.website-files.com/68abb1bb31e48d94e2e2ea89/68abb1bd31e48d94e2e2ec6e_15dd1e54f321bf475bfce97cf4df2614_New%20Logo%20Black.svg',
    activationStatus: WorkspaceActivationStatus.PENDING_CREATION, // will be set to active after default role creation
    isTwoFactorAuthenticationEnforced: false,
  },
} as const satisfies Record<
  SeededWorkspacesIds,
  Omit<CreateWorkspaceInput, 'version' | 'workspaceCustomApplicationId'>
>;
