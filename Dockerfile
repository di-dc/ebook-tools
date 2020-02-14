FROM debian:sid-slim

ENTRYPOINT ["bash"]

ENV HOME=/ebook-tools

RUN apt-get update && \
    apt-get --no-install-recommends -y install file less bash coreutils gawk sed grep calibre p7zip-full tesseract-ocr tesseract-ocr-osd tesseract-ocr-eng python-lxml poppler-utils catdoc djvulibre-bin locales curl ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 en_US.UTF-8 && \
    useradd -mUs /bin/bash -u 1000 user && \
    mkdir /ebook-tools && \
    chown user:user /ebook-tools

WORKDIR /ebook-tools

ENV LANG="en_US.UTF-8" PATH="${PATH}:/ebook-tools"

USER user

RUN curl 'https://www.mobileread.com/forums/attachment.php?attachmentid=176347' > goodreads.zip && \
    sha256sum 'goodreads.zip' | grep -q '247f4f62b2500af281e166c16bbe851c9a73b13d0b612adf1c390928ba014036' && \
    calibre-customize --add-plugin goodreads.zip && \
    rm goodreads.zip && \
    curl -L 'https://github.com/na--/calibre-worldcat-xisbn-metadata-plugin/releases/download/0.1/calibre-worldcat-xisbn-metadata-plugin-release-0.1.zip' > worldcat.zip && \
    sha256sum worldcat.zip | grep -q '82bd211f229a7db68c0d022b1ae403c298475978dbcdbea594dc7474ab4e9518' && \
    7z x worldcat.zip && \
    calibre-customize --add-plugin worldcat.zip && \
    rm -rf worldcat.zip

COPY . /ebook-tools
