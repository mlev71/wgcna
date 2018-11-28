#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs:
   counts: File
   name: string
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
         plot_name: name
         power: p
      out: [plot]


