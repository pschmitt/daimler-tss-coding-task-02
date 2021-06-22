FROM python:3.9-alpine

COPY ./merge_intervals.py /merge_intervals.py

ENTRYPOINT ["/merge_intervals.py"]
