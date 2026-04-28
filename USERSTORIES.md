## 1. Operational and Documentation Organisation                                                                                                                                   
  ### 1.1. Context                                                                                                                                                                   
  as a human in the loop (HIL), reviewing tdd unit tests is too granular for me. while unit tests are necessary, i want each develop-test-verify loop by inspecting functional       
  tests. these tests should be at the component level at minimum (maps to an epic/function/capability) and should either be in the form of verifying the shape of the data           
  transferred across the component (system/biz domain) boundary per openai's blog (https://openai.com/index/harness-engineering/), or should be verified against a natural language  
  description of an end to end test that simulates a ux journey if there's frontend involved.                                                                                        
  ### 1.2. Prescription                                                                                                                                                               
  That said, the harness should continue to follow TDD, with a layer of opinionated AGILE modeling and organising tasks and tests. Specifically, I would start with kind of like a   
  brainfart of what proj i want to build, and as you gather requirements these should be documented into a FRD.md that maps biz requirements to epics which correspond to functional 
   capability / components, ie. modules in code. Archi decisions should be decomented in ARD.md. assumptions and dependencies should be documented in CAVEATS.md. C4 L1 - L2 and     
  sequence diagrams should be drawn into ARCHI.md as mermaid models. Collectively these should correspond to the sweet specs document. the original brainfart when organised   
  into biz requiremetns can become a PRD that is analogous to the sweet plan document. If there are any gaps between my suggestion and sweet plan and specs you must     
  flag them out to me urgently.                                                                                                                                                      
  ## 2. Context aware requirements gathering                                                                                                                                         
  ### 2.1. Context                                                                                                                                                                   
  Sweet is great at spec'ing (tech requirements) but i feel it doesn't quite help to suggest for missing related features. Case in point: An agentic rag backend i built -     
  both myself and claude code missed out on handling figures and tables from a parsed pdf markdown file until much later when I noticed and suggested that these should have an      
  anchor reference and caption within the document and chunk, for separate agentic tool retrieval against figure / table storage.                                                       
  ### 2.2. Prescription                                                                                                                                                              
  Given my high level project brain fart requirements, you should probe for sample data or user story scenarios, to check if any data elements or scenario edge cases were missed    
  out. for user story scenarios, you can try to do a websearch of similar off the shelf tools and check their docs for a feature list if such analogous tools are avail. If web/docs   
  access is unavailable, ask me for comparable tools, sample data, screenshots, exports, docs, or realistic scenarios and perform the same missing-feature audit from those materials.
  ## 3. Failure modes documentation and self-improvement                                                                                                                             
  ### 3.1. Context                                                                                                                                                                   
  I see repeated failure patterns.                                                                                                                                                   
  ### 3.2. Prescription                                                                                                                                                              
  Come up with a skill / tool / hook to document failure patterns / modes before i run clear, compact or end session                                                                 
  ## 4. Memory to facilitate fresh sessions                                                                                                                                          
  ### 4.1. Context                                                                                                                                                                   
  I have to manually prompt the coding agent with refs to mem / git commit logs and planning docs which may be stale.                                                                
  ### 4.2. Prescription                                                                                                                                                              
  Need standardised repo structure per anthropic blog (https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)                                            
  Need to update memory after each component is built with design decisions, failure modes/patterns.                                                                                 
  Need to edit planning documents with any deviations or additional details.                                                                                                         
  Need to update FRD.md progress tracking whenever components are tested successfully against automated component acceptance gates: DTO/data-contract checks across boundaries,         
  automated e2e/user-flow scenarios, API scenario tests, Playwright/browser/computer-use automation, or equivalent project-specific harness checks.                                    
  Need to create a /preamble skill to generate a prefix to my first prompt for my new cleared session that captures what's next by bootstrapping from memory and reading git logs,   
  and has references to finished components, failure modes, and all planning docs.                                                                                                   
  Should suggest for me the user to clear or compact after each component is done (see: https://github.com/affaan-m/everything-claude-code/tree/main/skills/strategic-compact)       
  PreCompact Hook: Before context compaction happens, save important state to a file                                                                                                 
  SessionEnd Hook: On session end, persist learnings to a file                                                                                                                      
  SessionStart Hook: On new session, load previous context automatically                                                                                                             
  pre-compact.sh: Logs compaction events, updates active session file with compaction timestamp                                                                                      
  session-start.sh: Checks for recent session files (last 7 days), notifies of available context and learned skills                                                                  
  session-end.sh: Creates/updates daily session file with template, tracks start/end times                                                                                           
  ## 5. Wasted time scaffolding repo                                                                                                                                                 
  ### 5.1. Context                                                                                                                                                                   
  There are init / setup / config / env / etc. files that are common across all repos.                                                                                               
  ### 5.2. Prescription                                                                                                                                                              
  There should be a standardised way to bootstrap repos and come up with an init.sh script and/or makefile with common commands to spin up dev resources locally and/or on the       
  cloud, and to come up with a standard cicd pipeline with lint, type check, smoke test, etc. 
