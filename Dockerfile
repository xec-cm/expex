FROM francesccatala/shiny-verse:4.0.3

# Remove /srv/shiny-server content
RUN rm -rf /srv/shiny-server/*

# Copy covidseq_dev and set permission
ADD ./expex /srv/shiny-server

RUN chmod -R +r /srv/shiny-server

# Install covidapp and covidseq
RUN R -e "devtools::install('/srv/shiny-server')"

# Expose port
EXPOSE 3838
