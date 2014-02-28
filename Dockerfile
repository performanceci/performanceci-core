FROM promptworks/ruby-2.0.0
RUN yum install -y sqlite-devel gcc-c++
ADD . /data/
WORKDIR /data/
RUN bundle install
EXPOSE 4567
ENV RAILS_ENV production
RUN bundle exec rake db:migrate
#RUN bundle exec rake db:seed_perf
CMD ["bundle", "exec", "rails", "s", "-p", "4567"]
