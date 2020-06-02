#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool


baseCommand: ["Rscript", "/Users/mal8ch-admin/Dev/CWL/tsai/wgcna/wgcna_dendrogram.R"]

label: Identifies Coexpression Networks and Creates a Dendrogram from Expression Data

requirements:
- class: InlineJavascriptRequirement


inputs:
  expression:
    type: File
    label: Raw Expression Counts
    inputBinding:
      position: 1
      prefix: -i
  power:
    type: int
    label: Power for Adjacency Matrix Calculation
    inputBinding:
      position: 3
      prefix: --power

outputs:
  plot:
    type: File
    outputBinding:
      glob: 'output.png'


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
