import { FieldMetadataType } from 'twenty-shared/types';

import { type FieldMetadataSeed } from 'src/engine/workspace-manager/dev-seeder/metadata/types/field-metadata-seed.type';

export const OUTREACH_SEQUENCE_CUSTOM_RELATION_FIELD_SEEDS: (FieldMetadataSeed & {
  targetObjectMetadataNames: string[];
})[] = [
  {
    type: FieldMetadataType.RELATION,
    name: 'opportunity',
    label: 'Opportunity',
    description: 'Associated opportunity',
    icon: 'IconTargetArrow',
    isActive: true,
    isNullable: false,
    isUnique: false,
    targetObjectMetadataNames: ['opportunity'],
    relationType: 'MANY_TO_ONE',
  },
];
