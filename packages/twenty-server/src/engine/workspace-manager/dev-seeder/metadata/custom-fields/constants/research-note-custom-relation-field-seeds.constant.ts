import { FieldMetadataType } from 'twenty-shared/types';

import { type FieldMetadataSeed } from 'src/engine/workspace-manager/dev-seeder/metadata/types/field-metadata-seed.type';

export const RESEARCH_NOTE_CUSTOM_RELATION_FIELD_SEEDS: (FieldMetadataSeed & {
  targetObjectMetadataNames: string[];
})[] = [
  {
    type: FieldMetadataType.RELATION,
    name: 'company',
    label: 'Company',
    description: 'Company that was researched',
    icon: 'IconBuildingSkyscraper',
    isActive: true,
    isNullable: true,
    isUnique: false,
    targetObjectMetadataNames: ['company'],
    relationType: 'MANY_TO_ONE',
  },
  {
    type: FieldMetadataType.RELATION,
    name: 'person',
    label: 'Person',
    description: 'Person that was researched',
    icon: 'IconUser',
    isActive: true,
    isNullable: true,
    isUnique: false,
    targetObjectMetadataNames: ['person'],
    relationType: 'MANY_TO_ONE',
  },
];
