#!/usr/bin/env cwl-runner

schema_org:id:  https://doi.org/10.5281/zenodo.1656572

cwlVersion: v1.0
class: Workflow

inputs:
   counts: File
   p: int

outputs:
   dendrogram:
      type: File
      outputSource: plot/plot


steps:
   plot:
      run: wgcna.cwl
      in:
         expression: counts
         power: p
      out: [plot]

$namespaces:
  edam: http://edamontology.org/
  schema_org: http://schema.org/

$schemas:
- http://edamontology.org/EDAM_1.16.owl
- https://schema.org/version/latest/schema.rdf

schema_org:author:
  class: schema_org:Person
  schema_org:identifier: http://orcid.org/0000-0003-0384-8499
  schema_org:email: mal8ch@virginia.edu
  schema_org:name: Max Levinson
