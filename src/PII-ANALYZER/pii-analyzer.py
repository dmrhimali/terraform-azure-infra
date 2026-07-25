# uses (agent-helloworld) PS C:\Users\RasanjaleeDissanayak\TestProjects\terraform-azure-infra\src> .\.venv\Scripts\activate.ps1
# uv add presidio-analyzer presidio-anonymizer spacy
#  uv run python .\PII-ANALYZER\pii-analyzer.py
# 
from presidio_analyzer import AnalyzerEngine

# Initialize the analyzer
analyzer = AnalyzerEngine()

# Sample text with multiple PII types
text = """
Hi, my name is John Smith and I live in Seattle. 
My email is john.smith@example.com and my phone 
number is 206-555-0147. My SSN is 123-45-6789 
and my credit card is 4111-1111-1111-1111.
"""

# Analyze the text
results = analyzer.analyze(text=text, language="en")

# Print what we found
for result in results:
    print(f"{result.entity_type}: '{text[result.start:result.end].strip()}' "
          f"(score: {result.score:.2f}, position: {result.start}-{result.end})")

# output:
# (src) PS C:\Users\RasanjaleeDissanayak\TestProjects\terraform-azure-infra\src> uv run python .\PII-ANALYZER\pii-analyzer.py
# EMAIL_ADDRESS: 'john.smith@example.com' (score: 1.00, position: 63-85)
# UK_NHS: '206-555-0147' (score: 1.00, position: 110-122)
# CREDIT_CARD: '4111-1111-1111-1111' (score: 1.00, position: 169-188)
# PERSON: 'John Smith' (score: 0.85, position: 16-26)
# LOCATION: 'Seattle' (score: 0.85, position: 41-48)
# PHONE_NUMBER: '206-555-0147' (score: 0.75, position: 110-122)
# URL: 'john.sm' (score: 0.50, position: 63-70)
# URL: 'example.com' (score: 0.50, position: 74-85)
