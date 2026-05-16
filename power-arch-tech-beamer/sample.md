---
title: "Translation lookaside buffer and MMU Design for Multi-threaded architecture"
subtitle: "A Brief Overview"
topic: "MMU Design for Multi-threaded architecture"
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
# beamerarticle: true
theme: "CambridgeUS"
colortheme: "dolphin" # monarca, spruce, seahorse, beetle, albatross, crane, dove, orchid, whale, dolphin
# innertheme: "circles" # rectangles, Not Good: inmargin, rounded
outertheme: "miniframes" # miniframes, smoothbars, infolines, sidebar # Not Good: split smoothtree tree
fonttheme: "professionalfonts"
fontsize: 10pt
aspectratio: 169
section-titles: true
# toc: true
---

# Introduction

## About ISO 26262

- Functional Safety (FuSa) is the absence of unreasonable risk due to hazards
  caused by malfunctioning behaviour of Electrical and Electronics system.

- `ISO-26262` is a safety standard for road vehicles (cars, trucks).

::: columns
:::: column

![Achieving Functional Safety](./figs/about-asil.png "Optional title")

::::
:::: column

| **ASIL Grade** | **Fault Rate Requirements**             |
| :---------     | :----------:                            |
| ASIL-D         | >99% faults safe or detected, < 10 FIT  |
| ASIL-C         | >97% faults safe or detected, < 100 FIT |
| ASIL-B         | >90% faults safe or detected, < 100 FIT |
| ASIL-A         | >60% faults safe or detected            |

> **1 FIT(failure in time) = 1 failure in 10^9 (one billion) device hours**

::::
:::

## ISO 26262 parts

- The ISO 26262 is divided into 12 Parts:

  1. Definitions
  2. Management of Functional Safety
  3. Concept phase
  4. Product development at the system level
  5. Product development at the HW level
  6. Product development at the SW level
  7. Production and operation
  8. Supporting processes
  9. Automotive Safety Integrity Level (ASIL)- oriented and safety-oriented analyses
  10. Guideline on ISO 26262
  11. **Application of ISO 26262 to semiconductors**
  12. Adaptation for Motorcycles

<!-- ::: notes

This is my note.

- It can contain Markdown
- like this list

:::
 -->
## ISO 26262 part - 11

- ISO 26262-11 describes:

![ISO-26262 Part 11 Topics](./figs/iso26262-part11.png "Optional title"){ height=70% }


## Footnotes

Here is a footnote reference,[^1] and another.

Here is a footnote reference,[^2] and another.

Here is a footnote reference,[^xyz] and another.

[^1]: Here is the footnote.

[^2]: Rama .

[^xyz]: hare .




# Hardware faults in ISO-26262

## Radiation and ISO-26262

### Random Hardware failure
  - failure that can occur unpredictably during the lifetime of a hardware
    element and that follows a probability distribution.

![Types of Hardware Faults](./figs/random-hardware-fault.png "Optional title"){ height=70% }



## Fault, Errors and Failures

###
According to ISO-26262-1 definations:
_**Faults** create **Errors** which lead to **Faliures**._

![Relation between Faults, Errors and Failures](./figs/fault-error-failure.png "Optional title"){ height=70% }

---

How the fault leads to Error

![From Faults to Failures](./figs/bottom-up-failure-mode.png "Optional title"){ height=70% }


## Safety Metric for Random Hardware Failures

![The fault rate equation](./figs/failure-mode-equation.png "Optional title"){ height=70% }



# Failure Mode Distribution
## How Failure Mode Distribution is decided ?

The two major concerns while establishing the failure modes distribution of a processor are:

###
1. How to guarantee completeness of the analysis ?
2. How to assign the portion of the overall failure rate of the component to the
   identified failure modes with an acceptable level of accuracy ?

## How Failure Mode Distribution is decided ?

### How to guarantee completeness of the analysis

![White Box approach to Functional Safety](./figs/white-box-diagram.png "Optional title"){ height=30% }

Using **White Box** model, which consists of:

  - **Dividing** the component into Elementary Parts (EP) by using automatic tools
    to guarantee the completeness of the analysis.

  - **Computing** the ISO 26262 safety metrics by looking to the fault models of
    each elementary part, attributing the failure rate and estimating the
    diagnostic coverage of the planned HW or SW safety mechanisms.

  - **Verifying** the safety metrics by an extensive fault injection campaign
    simulating permanent, transient and common cause faults.



## How Failure Mode Distribution is decided ?

### How to assign the portion of the overall failure rate

  - Each digital circuit can be represented as a combination of Moore,
    or Mealy, machines.

  - The state flip-flop corresponds exactly with
    the endpoint of the fault-error-failure mode cone. Therefore, the flip-flops
    are the best endpoints for the failure mode analysis.

![Fault Mode Cone](./figs/fault-mode-cone.png "Optional title"){ height=70% }

---

- EDA tools are used in the fRMethodology flow to automatically extract the list
  of elementary parts from the design database

- The failure mode is defined by looking at the piece of functionality delivered
  by that elementary part. one failure mode can be linked to one or more elementary parts.

![Fault Mode Cone](./figs/fault-mode-cone.png "Optional title"){ height=70% }

---

- The next step is to estimate the failure modes distribution. This is done by
  attributing a weight to each failure mode. This is referred to as the
  “**combinational area ratio**”, or _CAR_.

- The weight is proportional to the number of logic gates generating the logic
  value of the elementary parts linked to that failure mode.

![Fault Mode Distribution](./figs/cone-table.png "Optional title"){ height=70% }



# faultRobust Methodology

## Understanding the fR-Methodology flow

![faultRobust Methodology flow](./figs/fRM-flow.png "Optional title"){ height=80% }


## Qualitative Analysis in fR-Methodology

The first stage identifies all the failure modes established through the
failure modes distribution process and for each of them adds the following:

> - The **Design Hierarchy**, for example, “CPU, Instruction Fetch Unit”. This means
    all the information needed to identify the location of the end points for
    which the failure mode is defined. The information here refers to the
    component, part and subpart hierarchy. The end points are the elementary
    parts.

> - A **detailed description of the failure mode**. For example, “Permanent Failure
    in the prefetch and fetch units control logic leading to wrong or missing
    fetch operation or deadlock”.

> - Information about whether or not the failure mode is **safety-relevant**.

> - A **description about the End Effect**. This means the resulting failure at the
    boundary of the processor or the high-level effect. For example, “Repeated
    changes in program execution order (conditions such as deadlock, slowdown or
    runaway could occur)”.

---

\begin{table}[]
\centering
\Huge
\resizebox{\textwidth}{!}{
\renewcommand{\arraystretch}{1.5}
\begin{tabular}{|l|c|l|l|c|l|c|}
\hline
\multicolumn{4}{|c|}{\textbf{Design Hierarchy}} & \multicolumn{3}{c|}{\textbf{\begin{tabular}[c]{@{}c@{}}Failure mode\\ Information\end{tabular}}} \\ \hline
\multicolumn{1}{|c|}{\textit{\begin{tabular}[c]{@{}c@{}}Faliure\\ Mode ID\end{tabular}}} & \textit{\begin{tabular}[c]{@{}c@{}}Component\\ Level\end{tabular}} & \multicolumn{1}{c|}{\textit{\begin{tabular}[c]{@{}c@{}}Block\\ Level\end{tabular}}} & \multicolumn{1}{c|}{\textit{\begin{tabular}[c]{@{}c@{}}Sub Block\\ Level\end{tabular}}} & \textit{\begin{tabular}[c]{@{}c@{}}Safety\\ Related\end{tabular}} & \multicolumn{1}{c|}{\textit{\begin{tabular}[c]{@{}c@{}}Faliure Mode\\ Descreption\end{tabular}}} & \textit{\begin{tabular}[c]{@{}c@{}}Potential and end effect\\ at CPU boundary\end{tabular}} \\ \hline
\textbf{FMEDA86} & CPU & DPU & Floating Point Unit & Y & Floating Point  Data Path computes wrong result & \textbf{Data Corruption} \\ \hline
\textbf{FMEDA225} & CPU & FPU & Dynamic Predictor ICG & Y & Clock gating failure leading to wrong branch predictor output leading to performance impact & \textbf{Performance} \\ \hline
\textbf{FMEDA82} & CPU & DCU & DCache ECC control logic & Y & Sends continous ECC invalidation requests to cache arbiter, blocking other requests & \textbf{Deadlock} \\ \hline
\end{tabular}
}
\caption{FMEDA Report Example}
\label{tab:my-table}
\end{table}


## Quantitative Analysis in fR-Methodology

In the fRMethodology quantitative analysis, each failure mode listed in the FMEA is annotated
with the failure rates associated with residual and multiple-point faults.

Essentially, taking the example of residual failures, the quantification process is based on the
following formula:

![Failure Rate Equation](./figs/krf-eq-small.png "Optional title"){ height=40% }

\begin{table}[]
\centering
\Huge
\resizebox{\textwidth}{!}{%
\begin{tabular}{|c|c|c|c|c|c|c|c|c|}
\hline
\multicolumn{9}{|c|}{\textbf{Permanent faults}} \\ \hline
\textbf{FM distribution} & \textbf{Failure rate} & \textbf{Fsafe} & \textbf{\begin{tabular}[c]{@{}c@{}}Fault detection \\ \& control mechanism\end{tabular}} & \textbf{\begin{tabular}[c]{@{}c@{}}Diagnostic coverage\\ (Krf)\end{tabular}} & \textbf{\begin{tabular}[c]{@{}c@{}}Residual / single point\\ failure rate\end{tabular}} & \textbf{\begin{tabular}[c]{@{}c@{}}Multiple point\\ failure rate\end{tabular}} & \textbf{\begin{tabular}[c]{@{}c@{}}Diagnostic coverage for \\ latent faults (Klat)\end{tabular}} & \textbf{\begin{tabular}[c]{@{}c@{}}Latent multiple point\\ failure rate\end{tabular}} \\ \hline
0.029\% & 3.01E-02 & 0.000\% & DCLS & 99.000\% & 3.01E-04 & 2.98E-02 & 100.000\% & 0.00E+00 \\ \hline
0.029\% & 3.01E-02 & 0.000\% & DCLS & 99.000\% & 3.01E-04 & 2.98E-02 & 100.000\% & 0.00E+00 \\ \hline
\end{tabular}%
}
\caption{Quantitative Analysis}
\label{tab:my-tab2}
\end{table}


## Summarising fR-Methodology

>- Splitting the component or system into elementary parts.
>- Identifying the respective fault models and failure modes.
>- Estimating the failure modes distribution.
>- Using this failure mode data to compute safety metrics.
>- Performing sensitivity analyses by changing architectural or technology parameters.
>- Validating the results with fault injection.


# Safety Lifecycle

## What is Safety Lifecycle ?

::: columns
:::: column

- IEC 61508 was the first standard to describe a safety life cycle.
- In IEC 61508 the life-cycle was used to define phases from the product idea up to
  the end of the product life, in which individual safety activities can be implemented.
- It is important to clearly document all safety issues.

::::
:::: column

![Safety Lifecycle Management](./figs/Safety-Lifecycle-Management.jpg "Optional title"){ height=80% }

::::
:::

## Safety Lifecycle according to ISO26262

ISO 26262 can only help to control hazards based on a malfunction of the product.

The aim of ISO 26262 is to define the responsibility of acting individuals,
departments and organizations that are responsible for each individual phase
of the safety lifecycle.
The safety-lifecycle is divided into 3 phases:

::: columns
:::: column

  1. Concept
  2. Product development
  3. After production release/approval

::::
:::: column

![ISO-26262 safety lifecycle](./figs/safety-lifecycle.png "Figure 2.10"){ height=80% }

::::
:::



## Security, Safety and Certain Norms

- Sufficient information has to be documented to the E/E-system for each phase of
  the safety-lifecycle, this is necessary for the effective fulfillment of the following
  phases and verification activities.

- Management of functional safety has to ensure the execution and documentation
  of phases and activities of the entire lifecycle is proper.

- The product lifecycle should be able to apply activities necessary for
  non-functional requirements such as security.

- Major security threads are :

  1. Availability
  2. Integrity
  3. Confidentiality

# Function Analysis

- A function analysis should start with function decomposition where we can see how
  a function is broken down from a higher abstraction level into a lower one
- Decomposition and the consolidation in the system integration will have to be
  necessary in all system levels since only limited resources can be provided in the systems
- It is inevitable when there has to be sufficient in-dependency & designated safety mechanism

![Function Analysis](./figs/function-analysis.png "Figure 4.6"){ height=55% }

# Hazard and Risk Analysis


::: columns
:::: column

- The objective of the hazard analysis and risk assessment is to identify
  and to categorize the hazards that malfunctions in the item.
- formulate the safety goals in accordance with ASIL for the prevention or mitigation of the
  hazardous events, in order to avoid unreasonable risk.

::::
:::: column

![Hazard and Risk Management Flow](./figs/hazard-flow.png "Figure 4.7"){ height=80% }

::::
:::



## Safety Goals

According to ISO 26262 safety goals are a result of hazard and risk analysis and
seen as safety requirements of the highest level.
The process of finding the safety goals can be summarized in the following steps :

  1. Identification of all the relevant hazards
  2. Identification of operational scenarios, modes, and environmental conditions etc.
  3. Combine Situations and the Hazardous Events
  4. Perform classification of Hazardous Events
  5. Identify Safety Goals that cover all Hazardous Events
  6. Single safety goal can refer to different dangers and several safety goals
     could refer to a single danger.

## Safety Goal Example

Formulations of Safety Goals Examples :

  1. Avoid an inadmissible pressure build-up of the brake pressure on one wheel
  2. Avoid an inadmissible torque build-up on one wheel
  3. Avoid a defective blockade of one wheel

\begin{table}[]
\centering
\resizebox{\textwidth}{!}{%
\begin{tabular}{|l|l|l|}
\hline
\multicolumn{1}{|c|}{\textbf{Hazard description}} &
  \multicolumn{1}{c|}{\textbf{ASIL}} &
  \multicolumn{1}{c|}{\textbf{Safety Goal}} \\ \hline
\textit{\begin{tabular}[c]{@{}l@{}}The LDW function activates in a condition which is in valid.\\ It suppresses intentional steering manouvers.\end{tabular}} &
  \textit{ASIL-D} &
  \textit{Driver should be able to cancel the LDW by moving steering in a counter active way} \\ \hline
\end{tabular}%
}
\caption{Example of Hazard Description}
\label{tab:my-table}
\end{table}


# Safety Concepts

- Safety concepts are first and foremost the planning basis for the safety measures,
  which are the safety mechanisms to be implemented within the safety-related
  product and the activities to be done additionally to the normal development
  activities.
- There are typically two concepts :
  1. Triple Module Redundancy based on voting.
  2. Redundant Systems for availability.

## Functional Safety Concept

The objective of the functional safety concept is to derive the functional
safety requirements, from the safety goals, and to allocate them to the preliminary
architectural elements of the item, or to external measures. The functional safety concept addresses :

1. Fault detection and Failure mitigation
2. Transitioning to a safe state
3. Fault tolerance mechanisms, where a fault does not lead directly to the
   violation of the safety goal(s) and which maintains the item in a safe state
   (with or without degradation)
4. Fault detection and driver warning in order to reduce the risk exposure
   time to an acceptable interval
5. Arbitration logic to select the most appropriate control request from
   multiple requests generated simultaneously by different functions

![Functional Safety Flow](./figs/info-flow.png "Figure 4.23"){ height=35% }

---

- Verifications are like a “repeat until loop”, unless the result is sufficient
- The verification criterion are correctness, consistency and completeness
  and sufficient traceability has been achieved, the safety goals, the derived
  functional safety requirements and their allocation to elements of the architecture



## Technical Safety Concept

- The first objective of this subphase is to specify the technical safety
  requirements. The technical safety requirements specification refines the
  functional safety concept, considering both the functional concept and the
  preliminary architectural assumptions
- The technical safety requirements are the technical requirements
  necessary to implement the functional safety concept

![Technical Safety Concept](./figs/tech-safety.png "Figure 4.24"){ height=50% }

## Microcontroller Safety Concept

- Microcontrollers have components like Counters, Quartz, Trigger, MUX. If these
  functional elements are used differently, they can cause functional failures.
- There are controllers for which the Safety Mechanisms are Built-In (BIST).
- There is a software package and a safety manual which explains how to configure
  the controller for safety applications and respctive ASIL.

![Microcontroller Safety Concept](./figs/uc-signal-chain.png "Figure 4.29"){ height=60% }



#
## _**`EoF`**_

\begin{center}
\Huge \emph{ Thank You !}
\end{center}


## **References**

References marked **(\*)** are confluence attachments.

::: columns
:::: column

- [ * Yogitech 2015 Presentation](http://192.168.1.194:8090/pages/worddav/preview.action?fileName=YT_RADWG_rev1.1.pdf&pageId=11010364)
- [ * ISO-26262 Part 11](http://192.168.1.194:8090/pages/worddav/preview.action?fileName=ISO_26262_11_2018_EN_FR.pdf.pdf&pageId=11010364)

::::
:::: column

- [ * Functional Safety for Road Vehicles - Book](http://192.168.1.194:8090/pages/worddav/preview.action?fileName=Hans-Leo+Ross+%28auth.%29+-+Functional+Safety+for+Road+Vehicles_+New+Challenges+and+Solutions+for+E-mobility+and+Automated+Driving.pdf&pageId=11010364)

::::
:::
