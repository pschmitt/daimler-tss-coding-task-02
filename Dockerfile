FROM python:3.9-alpine

COPY ./merge.py /merge.py

ENTRYPOINT ["/merge.py"]
