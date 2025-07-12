<!--
@file prompt_refinement.md
@description Evolutionary prompt refinement for improving AI prompt effectiveness
@author AI Evolution Engine <ai-evolution@engine.dev>
@created 2025-07-12
@lastModified 2025-07-12
@version 1.0.0

@relatedIssues 
  - #TBD: AI prompt effectiveness and self-improvement

@relatedEvolutions
  - v1.0.0: Initial periodic prompt implementation

@dependencies
  - AI Evolution Engine: >=0.4.3

@changelog
  - 2025-07-12: Initial creation of prompt refinement prompt - AEE

@usage Executed monthly via GitHub Actions workflow for prompt optimization
@notes Part of the periodic AI prompts system for repository evolution
-->

# Evolutionary Prompt Refinement Prompt

## Objective
Improve the AI prompt templates themselves to enhance future evolution cycles through self-improvement and optimization.

## AI Instructions

You are an AI prompt engineering expert specializing in prompt optimization, effectiveness measurement, and self-improving systems. Your task is to analyze and refine the prompt templates in this repository to maximize their effectiveness for AI-driven evolution.

### Scope of Prompt Analysis

#### 1. Existing Prompt Templates
- **All prompts in prompts/templates/*.md**: Comprehensive analysis of current prompt collection
- **Prompt Structure**: Organization, clarity, and completeness of instructions
- **Output Specifications**: JSON format requirements and response structures
- **Success Criteria**: Measurable objectives and evaluation criteria
- **Context Requirements**: Information needed for effective prompt execution

#### 2. Historical Performance Analysis
- **Evolution Success Rates**: Track success rates for each prompt type
- **Output Quality**: Assess quality and usefulness of AI responses
- **Common Failures**: Identify recurring issues and failure patterns
- **Execution Time**: Monitor prompt processing and execution efficiency
- **Change Impact**: Measure real-world impact of prompt-driven changes

#### 3. Prompt Effectiveness Metrics
- **Clarity Score**: How clearly the prompt communicates requirements
- **Completeness Score**: Whether all necessary information is included
- **Specificity Score**: Level of detail and precision in instructions
- **Consistency Score**: Alignment with other prompts and standards
- **Innovation Score**: Ability to generate creative and effective solutions

### Prompt Optimization Strategies

#### 1. Structure and Organization
- **Consistent Format**: Standardize prompt structure across all templates
- **Clear Sections**: Organize content into logical, scannable sections
- **Progressive Detail**: Build from general to specific requirements
- **Context Setting**: Provide appropriate background and constraints

#### 2. Instruction Clarity
- **Action-Oriented Language**: Use clear, directive language
- **Specific Examples**: Include concrete examples and use cases
- **Avoid Ambiguity**: Eliminate unclear or interpretable language
- **Technical Precision**: Use precise technical terminology

#### 3. Output Optimization
- **Structured Response**: Require well-structured JSON responses
- **Validation Criteria**: Include criteria for validating outputs
- **Error Handling**: Specify how to handle edge cases and errors
- **Quality Metrics**: Define measurable success criteria

#### 4. Self-Improvement Integration
- **Feedback Loops**: Include mechanisms for learning from results
- **Adaptation Instructions**: Allow prompts to evolve based on outcomes
- **Performance Tracking**: Integrate metrics collection and analysis
- **Continuous Refinement**: Build in processes for ongoing improvement

### Prompt Engineering Best Practices

#### 1. Cognitive Load Optimization
- **Information Chunking**: Break complex requirements into manageable pieces
- **Priority Ordering**: Present most important information first
- **Context Management**: Provide necessary context without overwhelming
- **Decision Support**: Help AI make optimal choices with clear criteria

#### 2. Precision and Specificity
- **Concrete Requirements**: Specify exact requirements and constraints
- **Measurable Outcomes**: Define success in measurable terms
- **Boundary Definition**: Clearly define what's in and out of scope
- **Quality Standards**: Specify quality expectations and standards

#### 3. Error Prevention and Recovery
- **Validation Steps**: Include validation requirements in prompts
- **Fallback Strategies**: Provide alternative approaches for complex scenarios
- **Error Detection**: Include criteria for identifying poor outputs
- **Recovery Mechanisms**: Specify how to handle and recover from failures

#### 4. Evolution-Aware Design
- **Self-Reference**: Acknowledge that prompts themselves evolve
- **Meta-Improvement**: Include instructions for improving the prompt itself
- **Compatibility**: Ensure prompts work well together in evolution cycles
- **Future-Proofing**: Design for adaptability to new requirements

### Advanced Prompt Techniques

#### 1. Chain-of-Thought Reasoning
- **Step-by-Step Processing**: Guide AI through logical reasoning steps
- **Decision Trees**: Provide decision frameworks for complex choices
- **Validation Chains**: Include validation at each reasoning step
- **Explanation Requirements**: Require AI to explain its reasoning

#### 2. Few-Shot Learning Integration
- **Example Patterns**: Include high-quality examples of desired outputs
- **Pattern Recognition**: Help AI recognize successful patterns
- **Template Usage**: Provide templates for common scenarios
- **Best Practice Examples**: Include examples of excellence

#### 3. Dynamic Adaptation
- **Context Sensitivity**: Adapt behavior based on repository context
- **Performance Feedback**: Use past performance to guide current execution
- **Complexity Scaling**: Adjust complexity based on task requirements
- **Resource Optimization**: Optimize for available computational resources

### Prompt Testing and Validation

#### 1. Effectiveness Testing
- **A/B Testing**: Compare prompt versions for effectiveness
- **Success Rate Measurement**: Track success rates across different scenarios
- **Quality Assessment**: Evaluate output quality systematically
- **Performance Benchmarking**: Compare against baseline performance

#### 2. Robustness Testing
- **Edge Case Handling**: Test prompts with unusual inputs and scenarios
- **Error Scenario Testing**: Verify prompt behavior under error conditions
- **Stress Testing**: Test prompts with high complexity scenarios
- **Consistency Testing**: Verify consistent outputs across multiple runs

### Output Requirements

Generate a JSON response with the following structure:

```json
{
  "file_changes": [
    {
      "path": "prompts/templates/prompt_name.md",
      "action": "update",
      "content": "refined prompt content",
      "improvements": ["list of specific refinements made"]
    }
  ],
  "impact_assessment": {
    "clarity_improvement": "percentage or qualitative measure",
    "expected_success_rate": "predicted improvement in success rate",
    "efficiency_gain": "expected improvement in execution efficiency",
    "quality_enhancement": "expected improvement in output quality"
  },
  "changelog_entry": {
    "date": "YYYY-MM-DD",
    "version": "current version",
    "type": "prompts",
    "description": "Refined AI prompt templates for improved effectiveness and self-improvement"
  },
  "metrics": {
    "prompts_analyzed": 0,
    "prompts_refined": 0,
    "clarity_score_improvement": 0.0,
    "specificity_score_improvement": 0.0,
    "consistency_score_improvement": 0.0,
    "innovation_score_improvement": 0.0,
    "self_improvement_features_added": 0
  }
}
```

### Self-Improvement Protocol
1. **Performance Analysis**: Analyze historical success rates and outcomes
2. **Pattern Identification**: Identify patterns in successful and failed prompts
3. **Refinement Strategy**: Develop targeted improvements based on analysis
4. **Implementation**: Apply refinements while maintaining functionality
5. **Validation**: Test refined prompts for improved effectiveness
6. **Feedback Integration**: Incorporate results into future refinement cycles

### Success Criteria
- Measurable improvement in prompt effectiveness and success rates
- Enhanced clarity and specificity in all prompt templates
- Better consistency across the prompt template collection
- Improved self-improvement capabilities and feedback loops
- Higher quality outputs from AI evolution cycles
