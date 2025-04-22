# BigDataManagement_Team


# Core Relationships
## allergies
patient → patients(id)
encounter → encounters(id)

## careplans
patient → patients(id)
encounter → encounters(id)

## claimsTransaction
patientid → patients(id)
claimid → claims(id)
appointmentid → encounters(id) (assuming appointmentid refers to encounters)
patientinsuranceid → payers(id)
providerid → providers(id)
supervisingproviderid → providers(id)

## claims
patientid → patients(id)
providerid → providers(id)
appointmentid → encounters(id)
supervisingproviderid → providers(id)

## conditions
patient → patients(id)
encounter → encounters(id)

## devices
patient → patients(id)
encounter → encounters(id)

## encounters
patient → patients(id)
organization → organizations(id)
provider → providers(id)
payer → payers(id)

## imaging_studies
patient → patients(id)
encounter → encounters(id)

## immunizations
patient → patients(id)
encounter → encounters(id)

## medications
patient → patients(id)
payer → payers(id)
encounter → encounters(id)

## observations
patient → patients(id)
encounter → encounters(id) (nullable)
payer_transitions
patient → patients(id)
payer → payers(id)
secondary_payer → payers(id)

## procedures
patient → patients(id)
encounter → encounters(id)

## providers
organization → organizations(id)

## supplies
patient → patients(id)
encounter → encounters(id)

# Domande
