from presidio_analyzer import AnalyzerEngine
from presidio_anonymizer import AnonymizerEngine

analyzer = AnalyzerEngine()
anonymizer = AnonymizerEngine()

text = "My name is John Smith and my email is john.smith@example.com"

# Detect PII
results = analyzer.analyze(text=text, language="en")

# Anonymize with default settings (replaces with entity type labels)
anonymized = anonymizer.anonymize(text=text, analyzer_results=results)

print(anonymized.text)
# Output: My name is <PERSON> and my email is <EMAIL_ADDRESS>