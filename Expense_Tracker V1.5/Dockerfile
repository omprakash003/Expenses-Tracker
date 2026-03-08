FROM python:3.11-slim
RUN apt-get update && apt-get install -y gnucobol
WORKDIR /app
COPY . .
RUN cobc -x add-expense.cob -o add-expense
RUN cobc -x view-total.cob -o view-total
RUN cobc -x view-records.cob -o view-records
RUN pip install flask
EXPOSE 5000
CMD ["python", "app.py"]