---
title: "MMU Design for Multi-threaded architecture"
subtitle: "TLB's for Non-Blocking access"
keywords: "MMU, Multi-threaded, TLB"
author:
- Somya Dashora
- Kalash Shah
# email: change author email in my_preamble.tex
# institute: Ceremorphic Internal Presentation
# date: 10/23/2021
# titlegraphic: ./figs/ceremorphic-logo.png # Change in my_preamble.tex
# background-image: ./figs/ceremorphic-logo.png ## Can be used for Watermark
#
# Beamer Related Options
#
theme: "CambridgeUS"
colortheme: "dolphin" # monarca, spruce, seahorse, beetle, albatross, crane, dove, orchid, whale, dolphin
# innertheme: "rounded" # rectangles, Not Good: inmargin, rounded
# outertheme: "miniframes" # miniframes, smoothbars, infolines, sidebar # Not Good: split smoothtree tree
fonttheme: "professionalfonts"
fontsize: 10pt
aspectratio: 169
section-titles: false
toc: true
toc-title: "Table of Contents"
---


# Background

  - Multi-threaded architecture try to maximize the number of common hardware resources
    that can be shared for multiple threads (For Ex. Caches, LSU, ALU, FPU).

![Fine Grain Multi Threading Architecture](./figs/FGMT.PNG "Optional title"){ height=50% }


  - Translation Lookaside Buffer contain virtual to Physical Address mapping for the
    whole system. The VA-ASID, PA pair are unique in whole system and managed by OS.

# Challenge / Problem

  - Implementing shared TLB's among multiple threads, simplifies the TLB invalidation Logic [^1].
  - When a Flush happens in a hart it invalidates all relevant TLB's entries as they are pooled in a
    common structure.

  - But a TLB miss from one threads request, should not cause a stall on all subsequent
    thread requests. This is further complicated as resolving a TLB miss is a long latency
    event (including second level TLB lookup followed by Page Table Walk steps [^2], which
    themselves cannot be parallelized.)

  - The subsequent threads should continue to utilize the TLB's and only the thread whose
    request caused the TLB's should stall, until Page Table Walks finish.


[^1]: No need for cross-core communication/invalidation.
[^2]: PTW steps include main-memory access via Data Cache hierarchy.

<!-- # Prior Works -->


# Our Approach

  - We design the TLB's and surrounding MMU logic in such a way that even on a TLB miss,
    the other threads continue to utilize the TLB's for lookup and
    continue their forward progress.

![MMU Design for Multi Threading Architecture](./figs/mmu-mt-arch.png "Optional title"){ height=70% }


# How it is Done ?

  - Dedicated Output register/port are kept for each thread to hold the relevant information
    such as (PPN for each threads lookup).

  - If a TLB miss occurs the relevant request packet is saved and sent to lower levels
    (second level TLB and PTW Unit), and the relevant output port is marked **transient**
    (meaning the translation is not available currently / will be available in some time)

  - In the subsequent clock cycles the other threads can continue to utilize the TLB's
    for translations and provide the output packet on their respective output ports.

  - A separate Thread selection/Arbitration logic is required to select and pass the
    appropriate physical Address to Instruction Cache.

# Claims

  - No Cross Thread dependencies (stalls) for TLB lookup, when this MMU (TLB) architecture is used.

