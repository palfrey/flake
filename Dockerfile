FROM msaraiva/erlang
RUN apk --update add git erlang-dev erlang-tools erlang-crypto erlang-syntax-tools erlang-reltool erlang-eunit erlang-sasl erlang-inets && apk upgrade erlang && rm -rf /var/cache/apk/*
RUN mkdir -p /opt/erlang/ && cd /opt/erlang && git clone git://github.com/rebar/rebar.git
RUN cd /opt/erlang/rebar && ./bootstrap
RUN ln -s /opt/erlang/rebar/rebar /usr/local/bin/rebar
RUN mkdir -p /opt/erlang/flake
WORKDIR /opt/erlang/flake
COPY . /opt/erlang/flake/
RUN sed -i 's/en0/eth0/' rel/files/sys.config
RUN echo -e "\n-noinput -noshell\n" >> rel/files/vm.args
RUN rebar get-deps clean compile generate
RUN rebar eunit app=flake
CMD ./rel/flake/bin/flake