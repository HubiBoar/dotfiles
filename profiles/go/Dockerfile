FROM cde/base

# ------- GO -------
WORKDIR /installer

RUN curl -OL https://golang.org/dl/go1.23.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xvf go1.23.4.linux-amd64.tar.gz && \
    rm -rf /installers

ENV PATH="$PATH:/usr/local/go/bin"



# ------- RUN -------

COPY root/ /root/
COPY scripts/ /scripts/

RUN nvim --headless "+Lazy! sync" +qall
RUN nvim --headless "+MasonInstallAll" +qall

RUN chmod +x /scripts/entrypoint.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
