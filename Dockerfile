FROM python:3.9-alpine

LABEL org.opencontainers.image.authors="Philipp Schmitt <philipp@schmitt.co>"

COPY ./merge_intervals.py /merge_intervals.py

ENTRYPOINT ["/merge_intervals.py"]
