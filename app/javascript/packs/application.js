import * as ActiveStorage from "activestorage";
import "../utils/direct_uploads.js"
import "../utils/text-editor.js"
import "../utils/shared.js"

import { displayLocationInfo } from 'packs/developer-form';
import { rangeDistance } from 'packs/developer-form';
import { hideRange } from 'packs/developer-form';
import { listParams } from 'packs/params-list';
import { uncheckFilter } from 'packs/params-list';
import { googleLocation } from 'packs/google-autocomplete';
import { rangeSalary } from 'packs/developer-form';
import { formRequest } from 'packs/index-search';
import { initFormSkill } from 'packs/form-skills';
import { collapsingButton } from 'packs/collapsing-button';

displayLocationInfo()
rangeDistance()
hideRange()
googleLocation()
rangeSalary()
formRequest()
listParams()
uncheckFilter()
collapsingButton()
