FROM promptworks/ruby-2.0.0
ADD . ~/
WORKDIR ~/
RUN bundle install
EXPOSE 4567
CMD ["simple.rb"]
ENTRYPOINT ["ruby"]
