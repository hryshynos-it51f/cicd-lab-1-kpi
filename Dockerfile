FROM nginx:alpine

# Видаляємо дефолтну сторінку nginx
RUN rm -rf /usr/share/nginx/html/*

# Копіюємо наші файли у стандартну папку nginx
COPY . /usr/share/nginx/html

# Порт 80 – стандартний HTTP
EXPOSE 80